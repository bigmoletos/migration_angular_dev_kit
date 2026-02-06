/**
 * Codemod: Remplace console.log/warn/error par LoggerService
 * 
 * Usage:
 *   npx jscodeshift -t scripts_outils_ia/codemods/console-to-logger.js src/**/*.ts --parser=ts
 * 
 * Dry-run (prévisualisation):
 *   npx jscodeshift -t scripts_outils_ia/codemods/console-to-logger.js src/**/*.ts --parser=ts --dry
 * 
 * Transformations:
 *   - console.log('msg')   → this.logger.log('msg')
 *   - console.warn('msg')  → this.logger.warn('msg')
 *   - console.error('msg') → this.logger.error('msg')
 *   - console.debug('msg') → this.logger.debug('msg')
 *   - console.info('msg')  → this.logger.info('msg')
 * 
 * Note: Ce codemod suppose que LoggerService est déjà injecté dans la classe.
 * Il ajoute un TODO si le logger n'est pas détecté.
 * 
 * @author Migration Angular 5→20
 * @version 1.0.0
 */

const CONSOLE_METHODS = ['log', 'warn', 'error', 'debug', 'info'];

module.exports = function transformer(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);
  let hasChanges = false;
  let hasConsoleUsage = false;
  let hasLoggerInjection = false;

  // 1. Vérifier si LoggerService est déjà injecté
  root.find(j.ClassDeclaration).forEach(classPath => {
    // Chercher dans le constructeur
    j(classPath).find(j.MethodDefinition, { kind: 'constructor' }).forEach(ctorPath => {
      const params = ctorPath.node.value.params;
      params.forEach(param => {
        // Vérifier les paramètres avec type LoggerService ou Logger
        if (param.parameter && param.parameter.typeAnnotation) {
          const typeAnnotation = param.parameter.typeAnnotation.typeAnnotation;
          if (typeAnnotation && typeAnnotation.typeName) {
            const typeName = typeAnnotation.typeName.name;
            if (typeName === 'LoggerService' || typeName === 'Logger' || typeName === 'NGXLogger') {
              hasLoggerInjection = true;
            }
          }
        }
        // Vérifier aussi les paramètres simples avec type
        if (param.typeAnnotation) {
          const typeAnnotation = param.typeAnnotation.typeAnnotation;
          if (typeAnnotation && typeAnnotation.typeName) {
            const typeName = typeAnnotation.typeName.name;
            if (typeName === 'LoggerService' || typeName === 'Logger' || typeName === 'NGXLogger') {
              hasLoggerInjection = true;
            }
          }
        }
      });
    });

    // Chercher aussi les propriétés de classe
    j(classPath).find(j.ClassProperty).forEach(propPath => {
      if (propPath.node.typeAnnotation) {
        const typeAnnotation = propPath.node.typeAnnotation.typeAnnotation;
        if (typeAnnotation && typeAnnotation.typeName) {
          const typeName = typeAnnotation.typeName.name;
          if (typeName === 'LoggerService' || typeName === 'Logger' || typeName === 'NGXLogger') {
            hasLoggerInjection = true;
          }
        }
      }
    });
  });

  // 2. Remplacer les appels console.xxx par this.logger.xxx
  root.find(j.CallExpression, {
    callee: {
      type: 'MemberExpression',
      object: { name: 'console' }
    }
  }).forEach(path => {
    const method = path.node.callee.property.name;
    
    if (CONSOLE_METHODS.includes(method)) {
      hasConsoleUsage = true;
      
      // Créer this.logger.method(...)
      path.node.callee = j.memberExpression(
        j.memberExpression(j.thisExpression(), j.identifier('logger')),
        j.identifier(method)
      );
      
      hasChanges = true;
    }
  });

  // 3. Si console utilisé mais pas de logger injecté, ajouter un commentaire TODO
  if (hasConsoleUsage && !hasLoggerInjection) {
    // Ajouter un commentaire au début du fichier
    const body = root.get().node.program.body;
    if (body.length > 0) {
      const firstNode = body[0];
      if (!firstNode.comments) {
        firstNode.comments = [];
      }
      
      // Vérifier si le TODO n'existe pas déjà
      const hasTodo = firstNode.comments.some(c => 
        c.value.includes('TODO: Injecter LoggerService')
      );
      
      if (!hasTodo) {
        firstNode.comments.unshift(
          j.commentLine(' TODO: Injecter LoggerService dans le constructeur de cette classe'),
          j.commentLine(' import { LoggerService } from \'@core/services/logger.service\';'),
          j.commentLine(' constructor(private logger: LoggerService) { }')
        );
      }
    }
  }

  if (hasChanges) {
    return root.toSource({ quote: 'single' });
  }

  return null;
};
