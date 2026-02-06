/**
 * Codemod: Migration des imports RxJS 5 vers RxJS 6+
 * 
 * Usage:
 *   npx jscodeshift -t scripts_outils_ia/codemods/rxjs-imports.js src/**/*.ts --parser=ts
 * 
 * Dry-run (prévisualisation):
 *   npx jscodeshift -t scripts_outils_ia/codemods/rxjs-imports.js src/**/*.ts --parser=ts --dry
 * 
 * Transformations:
 *   - import { Observable } from 'rxjs/Observable' → import { Observable } from 'rxjs'
 *   - import { map } from 'rxjs/operators/map' → import { map } from 'rxjs/operators'
 *   - import 'rxjs/add/operator/map' → supprimé (operators pipeable)
 *   - import { Subject } from 'rxjs/Subject' → import { Subject } from 'rxjs'
 * 
 * @author Migration Angular 5→20
 * @version 1.0.0
 */

// Mapping des anciens imports vers les nouveaux
const RXJS_CORE_IMPORTS = [
  'Observable',
  'Subject',
  'BehaviorSubject',
  'ReplaySubject',
  'AsyncSubject',
  'Subscription',
  'Subscriber',
  'Notification',
  'ConnectableObservable',
  'GroupedObservable',
  'Scheduler',
  'VirtualTimeScheduler',
  'ObjectUnsubscribedError',
  'UnsubscriptionError',
  'ArgumentOutOfRangeError',
  'EmptyError',
  'TimeoutError',
  'pipe',
  'noop',
  'identity',
  'isObservable',
  'of',
  'from',
  'fromEvent',
  'fromEventPattern',
  'fromPromise',
  'interval',
  'timer',
  'range',
  'empty',
  'never',
  'throwError',
  'defer',
  'forkJoin',
  'merge',
  'concat',
  'combineLatest',
  'zip',
  'race',
  'EMPTY',
  'NEVER',
  'animationFrameScheduler',
  'asapScheduler',
  'asyncScheduler',
  'queueScheduler',
];

const RXJS_OPERATORS = [
  'audit',
  'auditTime',
  'buffer',
  'bufferCount',
  'bufferTime',
  'bufferToggle',
  'bufferWhen',
  'catchError',
  'combineAll',
  'combineLatestWith',
  'concatAll',
  'concatMap',
  'concatMapTo',
  'count',
  'debounce',
  'debounceTime',
  'defaultIfEmpty',
  'delay',
  'delayWhen',
  'dematerialize',
  'distinct',
  'distinctUntilChanged',
  'distinctUntilKeyChanged',
  'elementAt',
  'endWith',
  'every',
  'exhaust',
  'exhaustMap',
  'expand',
  'filter',
  'finalize',
  'find',
  'findIndex',
  'first',
  'groupBy',
  'ignoreElements',
  'isEmpty',
  'last',
  'map',
  'mapTo',
  'materialize',
  'max',
  'merge',
  'mergeAll',
  'mergeMap',
  'flatMap', // alias de mergeMap
  'mergeMapTo',
  'mergeScan',
  'mergeWith',
  'min',
  'multicast',
  'observeOn',
  'pairwise',
  'partition',
  'pluck',
  'publish',
  'publishBehavior',
  'publishLast',
  'publishReplay',
  'raceWith',
  'reduce',
  'refCount',
  'repeat',
  'repeatWhen',
  'retry',
  'retryWhen',
  'sample',
  'sampleTime',
  'scan',
  'sequenceEqual',
  'share',
  'shareReplay',
  'single',
  'skip',
  'skipLast',
  'skipUntil',
  'skipWhile',
  'startWith',
  'subscribeOn',
  'switchAll',
  'switchMap',
  'switchMapTo',
  'take',
  'takeLast',
  'takeUntil',
  'takeWhile',
  'tap',
  'do', // ancien nom de tap
  'throttle',
  'throttleTime',
  'throwIfEmpty',
  'timeInterval',
  'timeout',
  'timeoutWith',
  'timestamp',
  'toArray',
  'window',
  'windowCount',
  'windowTime',
  'windowToggle',
  'windowWhen',
  'withLatestFrom',
  'zipAll',
  'zipWith',
];

// Opérateurs renommés dans RxJS 6
const RENAMED_OPERATORS = {
  'do': 'tap',
  'catch': 'catchError',
  'switch': 'switchAll',
  'finally': 'finalize',
  'flatMap': 'mergeMap',
  'throw': 'throwError',
};

module.exports = function transformer(file, api) {
  const j = api.jscodeshift;
  const root = j(file.source);
  let hasChanges = false;

  // Collecter tous les imports RxJS à consolider
  const coreImports = new Set();
  const operatorImports = new Set();
  const importsToRemove = [];

  // 1. Analyser les imports existants
  root.find(j.ImportDeclaration).forEach(path => {
    const source = path.node.source.value;

    // Supprimer les imports 'rxjs/add/operator/*' (patch operators)
    if (source.startsWith('rxjs/add/')) {
      importsToRemove.push(path);
      hasChanges = true;
      return;
    }

    // Transformer 'rxjs/Observable' → collecter pour 'rxjs'
    if (source.match(/^rxjs\/(Observable|Subject|BehaviorSubject|ReplaySubject|AsyncSubject|Subscription|Scheduler)$/)) {
      const specifiers = path.node.specifiers;
      specifiers.forEach(spec => {
        if (spec.type === 'ImportDefaultSpecifier' || spec.type === 'ImportSpecifier') {
          const name = spec.imported ? spec.imported.name : spec.local.name;
          coreImports.add(name);
        }
      });
      importsToRemove.push(path);
      hasChanges = true;
      return;
    }

    // Transformer 'rxjs/observable/*' → collecter pour 'rxjs'
    if (source.match(/^rxjs\/observable\//)) {
      const specifiers = path.node.specifiers;
      specifiers.forEach(spec => {
        if (spec.imported) {
          coreImports.add(spec.imported.name);
        }
      });
      importsToRemove.push(path);
      hasChanges = true;
      return;
    }

    // Transformer 'rxjs/operators/*' → collecter pour 'rxjs/operators'
    if (source.match(/^rxjs\/operators?\//)) {
      const specifiers = path.node.specifiers;
      specifiers.forEach(spec => {
        if (spec.imported) {
          let opName = spec.imported.name;
          // Renommer si nécessaire
          if (RENAMED_OPERATORS[opName]) {
            opName = RENAMED_OPERATORS[opName];
          }
          operatorImports.add(opName);
        }
      });
      importsToRemove.push(path);
      hasChanges = true;
      return;
    }

    // Gérer 'rxjs' existant - ajouter à la collection
    if (source === 'rxjs') {
      const specifiers = path.node.specifiers;
      specifiers.forEach(spec => {
        if (spec.imported) {
          coreImports.add(spec.imported.name);
        }
      });
      importsToRemove.push(path);
      hasChanges = true;
      return;
    }

    // Gérer 'rxjs/operators' existant
    if (source === 'rxjs/operators') {
      const specifiers = path.node.specifiers;
      specifiers.forEach(spec => {
        if (spec.imported) {
          let opName = spec.imported.name;
          if (RENAMED_OPERATORS[opName]) {
            opName = RENAMED_OPERATORS[opName];
          }
          operatorImports.add(opName);
        }
      });
      importsToRemove.push(path);
      hasChanges = true;
      return;
    }
  });

  // 2. Supprimer les anciens imports
  importsToRemove.forEach(path => {
    j(path).remove();
  });

  // 3. Ajouter les nouveaux imports consolidés
  if (coreImports.size > 0) {
    const coreSpecifiers = Array.from(coreImports)
      .sort()
      .map(name => j.importSpecifier(j.identifier(name)));
    
    const coreImport = j.importDeclaration(coreSpecifiers, j.literal('rxjs'));
    
    // Insérer au début du fichier (après les autres imports existants)
    const body = root.get().node.program.body;
    const firstNonImport = body.findIndex(node => node.type !== 'ImportDeclaration');
    if (firstNonImport > 0) {
      body.splice(firstNonImport, 0, coreImport);
    } else if (firstNonImport === 0) {
      body.unshift(coreImport);
    } else {
      body.push(coreImport);
    }
  }

  if (operatorImports.size > 0) {
    const opSpecifiers = Array.from(operatorImports)
      .sort()
      .map(name => j.importSpecifier(j.identifier(name)));
    
    const opImport = j.importDeclaration(opSpecifiers, j.literal('rxjs/operators'));
    
    const body = root.get().node.program.body;
    const firstNonImport = body.findIndex(node => node.type !== 'ImportDeclaration');
    if (firstNonImport > 0) {
      body.splice(firstNonImport, 0, opImport);
    } else if (firstNonImport === 0) {
      body.unshift(opImport);
    } else {
      body.push(opImport);
    }
  }

  // 4. Renommer les opérateurs dans le code
  Object.entries(RENAMED_OPERATORS).forEach(([oldName, newName]) => {
    root.find(j.Identifier, { name: oldName }).forEach(path => {
      // Vérifier que c'est bien un appel d'opérateur RxJS
      const parent = path.parent;
      if (parent && parent.node.type === 'CallExpression') {
        path.node.name = newName;
        hasChanges = true;
      }
    });
  });

  if (hasChanges) {
    return root.toSource({ quote: 'single' });
  }

  return null;
};
