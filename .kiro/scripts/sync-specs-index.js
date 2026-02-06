#!/usr/bin/env node

/**
 * Script de synchronisation automatique de l'index des specs
 *
 * Ce script :
 * 1. Scanne tous les fichiers .md dans .kiro/specs/ (sauf README.md et _index.json)
 * 2. Génère automatiquement le fichier _index.json à jour
 * 3. Peut être appelé manuellement ou via un hook
 *
 * Usage:
 *   node sync-specs-index.js
 */

const fs = require('fs');
const path = require('path');

// Configuration
const SPECS_DIR = path.join(__dirname, '..', 'specs');
const INDEX_FILE = path.join(SPECS_DIR, '_index.json');
const IGNORE_FILES = ['README.md', '_index.json'];

// Estimation approximative des tokens par spec (peut être ajustée)
const TOKENS_PER_SPEC = 4000;

/**
 * Extrait les métadonnées d'un fichier spec
 */
function extractSpecMetadata(filename) {
  const filePath = path.join(SPECS_DIR, filename);
  const content = fs.readFileSync(filePath, 'utf8');

  // Extraire le titre (première ligne avec #)
  const titleMatch = content.match(/^#\s+(.+)$/m);
  const title = titleMatch ? titleMatch[1] : filename.replace('.md', '');

  // Extraire une description (premier paragraphe ou ligne après le titre)
  const descMatch = content.match(/^#\s+.+\n\n(.+?)(?:\n\n|$)/s);
  const description = descMatch ? descMatch[1].replace(/\n/g, ' ').substring(0, 100) : title;

  // Générer des mots-clés à partir du nom de fichier et du titre
  const keywords = extractKeywords(filename, title);

  // Estimation du nombre de tokens
  const tokenEstimate = Math.ceil(content.length / 4); // Approximation : 4 caractères = 1 token

  return {
    name: filename.replace('.md', ''),
    path: filename,
    description: description,
    keywords: keywords,
    tokenEstimate: tokenEstimate
  };
}

/**
 * Extrait des mots-clés pertinents
 */
function extractKeywords(filename, title) {
  const keywords = new Set();

  // Mots-clés du nom de fichier
  const filenameParts = filename.replace('.md', '').split(/[-_]/);
  filenameParts.forEach(part => {
    if (part.length > 2 && !part.match(/^\d+$/)) {
      keywords.add(part.toLowerCase());
    }
  });

  // Mots-clés du titre
  const titleWords = title.toLowerCase().split(/\s+/);
  titleWords.forEach(word => {
    if (word.length > 3 && !['pour', 'dans', 'avec', 'sans'].includes(word)) {
      keywords.add(word);
    }
  });

  return Array.from(keywords);
}

/**
 * Génère l'index complet
 */
function generateIndex() {
  console.log('🔍 Scan du dossier specs...');

  // Lire tous les fichiers .md
  const files = fs.readdirSync(SPECS_DIR)
    .filter(file => file.endsWith('.md') && !IGNORE_FILES.includes(file))
    .sort();

  console.log(`📄 ${files.length} specs trouvées`);

  // Générer les métadonnées pour chaque spec
  const specs = files.map(file => {
    const metadata = extractSpecMetadata(file);
    console.log(`   ✓ ${file} (${metadata.tokenEstimate} tokens)`);
    return metadata;
  });

  // Calculer les statistiques
  const totalTokens = specs.reduce((sum, spec) => sum + spec.tokenEstimate, 0);

  // Générer l'objet index
  const index = {
    version: "1.0",
    description: "Index des specs - NON chargées automatiquement",
    lastUpdated: new Date().toISOString().split('T')[0],

    loadingStrategy: {
      mode: "explicit",
      note: "Les specs ne sont chargées que sur demande explicite"
    },

    specs: specs,

    statistics: {
      totalSpecs: specs.length,
      totalTokensIfAllLoaded: totalTokens
    },

    usage: "Référencer une spec avec son nom: 'Exécute la spec 00-coordination-migration'"
  };

  // Écrire le fichier index
  fs.writeFileSync(INDEX_FILE, JSON.stringify(index, null, 2), 'utf8');

  console.log(`\n✅ Index mis à jour : ${INDEX_FILE}`);
  console.log(`📊 Total : ${specs.length} specs, ${totalTokens} tokens estimés`);

  return index;
}

// Exécution
try {
  const index = generateIndex();
  process.exit(0);
} catch (error) {
  console.error('❌ Erreur lors de la synchronisation :', error.message);
  process.exit(1);
}
