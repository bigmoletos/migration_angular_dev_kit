/**
 * Codemod: Ajoute { static: false } aux @ViewChild et @ContentChild
 * 
 * Contexte:
 *   Angular 8+ requiert l'option 'static' explicite pour @ViewChild/@ContentChild.
 *   Angular 9+ (Ivy) a changé le comportement par défaut.
 * 
 * Usage:
 *   npx jscodeshift -t scripts_outils_ia/codemods/viewchild-static.js src/**/*.ts --parser=ts
 * 
 * Dry-run (prévisualisation):
 *   npx jscodeshift -t scripts_outils_ia/codemods/viewchild-static.js src/**/*.ts --parser=ts --dry
 * 
 * Transformations:
 *   - @ViewChild('ref') el: ElementRef        → @ViewChild('ref', { static: false }) el: ElementRef
 *   - @ViewChild(MyComponent) comp: MyComp    → @ViewChild(MyComponent, { static: false }) comp: MyComp
 *   - @ContentChild('ref') el: ElementRef     → @ContentChild('ref', { static: false }) el: ElementRef
 *   - @ViewChildren(...) déjà OK (pas de static)
 * 
 * Note: static: true est nécessaire uniquement si le ViewChild est utilisé dans ngOnInit.
 *       Par défaut, static: false est plus sûr.
 * 
 * @author Migration Angular 5→20
 * @version 1.0.0
 */

module.exports = function transformer(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);
  let hasChanges = false;

  // Trouver tous les décorateurs @ViewChild et @ContentChild
  root.find(j.Decorator).forEach(path => {
    const expression = path.node.expression;
    
    // Vérifier si c'est un appel de fonction (décorateur avec arguments)
    if (expression.type !== 'CallExpression') {
      return;
    }

    const callee = expression.callee;
    
    // Vérifier si c'est @ViewChild ou @ContentChild
    if (callee.type !== 'Identifier') {
      return;
    }
    
    const decoratorName = callee.name;
    if (decoratorName !== 'ViewChild' && decoratorName !== 'ContentChild') {
      return;
    }

    const args = expression.arguments;
    
    // Si pas d'arguments, ignorer (cas invalide)
    if (args.length === 0) {
      return;
    }

    // Si déjà 2 arguments (selector + options), vérifier si static est défini
    if (args.length >= 2) {
      const optionsArg = args[1];
      
      // Si c'est un objet, vérifier s'il contient static
      if (optionsArg.type === 'ObjectExpression') {
        const hasStatic = optionsArg.properties.some(prop => {
          return prop.key && (prop.key.name === 'static' || prop.key.value === 'static');
        });
        
        // Si static n'est pas défini, l'ajouter
        if (!hasStatic) {
          optionsArg.properties.push(
            j.property('init', j.identifier('static'), j.literal(false))
          );
          hasChanges = true;
        }
      }
      return;
    }

    // Si 1 seul argument (juste le selector), ajouter { static: false }
    if (args.length === 1) {
      const staticOption = j.objectExpression([
        j.property('init', j.identifier('static'), j.literal(false))
      ]);
      
      expression.arguments.push(staticOption);
      hasChanges = true;
    }
  });

  if (hasChanges) {
    return root.toSource({ quote: 'single' });
  }

  return null;
};
