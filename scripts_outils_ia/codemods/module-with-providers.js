/**
 * Codemod: Ajoute le type générique à ModuleWithProviders
 * 
 * Contexte:
 *   Angular 10+ requiert ModuleWithProviders<T> au lieu de ModuleWithProviders
 * 
 * Usage:
 *   npx jscodeshift -t scripts_outils_ia/codemods/module-with-providers.js src/**/*.ts --parser=ts
 * 
 * Dry-run (prévisualisation):
 *   npx jscodeshift -t scripts_outils_ia/codemods/module-with-providers.js src/**/*.ts --parser=ts --dry
 * 
 * Transformations:
 *   - static forRoot(): ModuleWithProviders { ... }
 *     → static forRoot(): ModuleWithProviders<MyModule> { ... }
 * 
 *   - static forChild(): ModuleWithProviders { ... }
 *     → static forChild(): ModuleWithProviders<MyModule> { ... }
 * 
 * @author Migration Angular 5→20
 * @version 1.0.0
 */

module.exports = function transformer(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);
  let hasChanges = false;

  // Trouver le nom du module dans ce fichier
  let moduleName = null;

  // Chercher la classe décorée avec @NgModule
  root.find(j.ClassDeclaration).forEach(classPath => {
    const decorators = classPath.node.decorators || [];
    
    const hasNgModule = decorators.some(dec => {
      if (dec.expression.type === 'CallExpression') {
        return dec.expression.callee.name === 'NgModule';
      }
      if (dec.expression.type === 'Identifier') {
        return dec.expression.name === 'NgModule';
      }
      return false;
    });

    if (hasNgModule && classPath.node.id) {
      moduleName = classPath.node.id.name;
    }
  });

  // Si pas de module trouvé, essayer de déduire du nom du fichier
  if (!moduleName) {
    const fileName = file.path;
    const match = fileName.match(/([a-zA-Z0-9-]+)\.module\.ts$/);
    if (match) {
      // Convertir kebab-case en PascalCase
      moduleName = match[1]
        .split('-')
        .map(part => part.charAt(0).toUpperCase() + part.slice(1))
        .join('') + 'Module';
    }
  }

  // Chercher les méthodes statiques forRoot/forChild qui retournent ModuleWithProviders
  root.find(j.MethodDefinition, { static: true }).forEach(methodPath => {
    const methodName = methodPath.node.key.name;
    
    // Vérifier si c'est forRoot ou forChild
    if (methodName !== 'forRoot' && methodName !== 'forChild') {
      return;
    }

    const returnType = methodPath.node.value.returnType;
    
    if (!returnType || !returnType.typeAnnotation) {
      return;
    }

    const typeAnnotation = returnType.typeAnnotation;

    // Cas 1: TSTypeReference simple (ModuleWithProviders sans générique)
    if (typeAnnotation.type === 'TSTypeReference') {
      const typeName = typeAnnotation.typeName;
      
      // Vérifier que c'est bien ModuleWithProviders
      if (typeName.type === 'Identifier' && typeName.name === 'ModuleWithProviders') {
        // Vérifier s'il n'y a pas déjà de type générique
        if (!typeAnnotation.typeParameters) {
          // Ajouter le type générique
          if (moduleName) {
            typeAnnotation.typeParameters = j.tsTypeParameterInstantiation([
              j.tsTypeReference(j.identifier(moduleName))
            ]);
            hasChanges = true;
          } else {
            // Si on ne peut pas déterminer le nom du module, ajouter un TODO
            console.warn(`[WARN] Cannot determine module name for ${file.path}`);
            console.warn('       Please manually add the generic type: ModuleWithProviders<YourModule>');
          }
        }
      }
    }
  });

  // Chercher aussi les fonctions (pas seulement les méthodes de classe)
  root.find(j.FunctionDeclaration).forEach(funcPath => {
    const funcName = funcPath.node.id ? funcPath.node.id.name : null;
    
    if (funcName !== 'forRoot' && funcName !== 'forChild') {
      return;
    }

    const returnType = funcPath.node.returnType;
    
    if (!returnType || !returnType.typeAnnotation) {
      return;
    }

    const typeAnnotation = returnType.typeAnnotation;

    if (typeAnnotation.type === 'TSTypeReference') {
      const typeName = typeAnnotation.typeName;
      
      if (typeName.type === 'Identifier' && typeName.name === 'ModuleWithProviders') {
        if (!typeAnnotation.typeParameters && moduleName) {
          typeAnnotation.typeParameters = j.tsTypeParameterInstantiation([
            j.tsTypeReference(j.identifier(moduleName))
          ]);
          hasChanges = true;
        }
      }
    }
  });

  if (hasChanges) {
    return root.toSource({ quote: 'single' });
  }

  return null;
};
