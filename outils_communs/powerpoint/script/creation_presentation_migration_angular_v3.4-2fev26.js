/**
 * Présentation Migration Angular 5 → 20 - Version 3.4
 * Date: 2 février 2026
 * 
 * Modifications v3.4 :
 * - Slide 4 séparé en deux : Fork (slide 4) + MODOP/Codemods (slide 5)
 * - Introduction concept codemods avec exemple concret
 * - Mention applicabilité à tous les projets
 * - Nouveau nom : Migration PWC - Franck Desmedt
 * 
 * Usage: node create-presentation-v3.4.js
 */

const pptxgen = require("pptxgenjs");

const THEME = {
  primary: "1A365D",
  secondary: "2B6CB0",
  accent: "63B3ED",
  dark: "0F172A",
  light: "F7FAFC",
  white: "FFFFFF",
  gray: "718096",
  success: "38A169",
  warning: "D69E2E",
  danger: "E53E3E",
  fontTitle: "Calibri Light",
  fontBody: "Calibri",
  headingSize: 28,
};

const AUTHOR = "Migration PWC - Franck Desmedt";

let pres = new pptxgen();
pres.layout = "LAYOUT_16x9";
pres.title = "Migration Angular 5 → 20";
pres.author = AUTHOR;

// ============================================================================
// SLIDE 1 : TITRE
// ============================================================================

let slide1 = pres.addSlide();
slide1.background = { color: THEME.primary };

slide1.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 10, h: 0.15,
  fill: { color: THEME.accent }
});

slide1.addText("Migration Angular", {
  x: 0.5, y: 1.8, w: 9, h: 1,
  fontSize: 48, fontFace: THEME.fontTitle, color: THEME.white,
  align: "center"
});

slide1.addText("Version 5 → 20", {
  x: 0.5, y: 2.7, w: 9, h: 0.8,
  fontSize: 36, fontFace: THEME.fontTitle, color: THEME.accent,
  align: "center"
});

slide1.addText("Présentation d'avancement projet", {
  x: 0.5, y: 3.8, w: 9, h: 0.5,
  fontSize: 20, fontFace: THEME.fontBody, color: THEME.light,
  align: "center"
});

slide1.addShape(pres.shapes.RECTANGLE, {
  x: 3.5, y: 4.4, w: 3, h: 0.03,
  fill: { color: THEME.accent }
});

slide1.addText(AUTHOR, {
  x: 0.5, y: 5.0, w: 9, h: 0.4,
  fontSize: 14, fontFace: THEME.fontBody, color: THEME.gray,
  align: "center"
});

// ============================================================================
// SLIDE 2 : AGENDA
// ============================================================================

let slide2 = pres.addSlide();
slide2.background = { color: THEME.light };

slide2.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 0.12, h: 5.625,
  fill: { color: THEME.primary }
});

slide2.addText("Agenda", {
  x: 0.5, y: 0.3, w: 9, h: 0.7,
  fontSize: THEME.headingSize, fontFace: THEME.fontTitle, color: THEME.primary,
  bold: true, margin: 0
});

const agendaItems = [
  { num: "01", text: "Contexte et périmètre du projet" },
  { num: "02", text: "Approche sécurisée : travail sur fork" },
  { num: "03", text: "Mode opératoire et codemods" },
  { num: "04", text: "Configuration du poste de travail" },
  { num: "05", text: "Stratégie de migration par paliers" },
  { num: "06", text: "Outillage IA et workflow stateful" },
  { num: "07", text: "Journal de bord et traçabilité" },
  { num: "08", text: "État d'avancement" },
  { num: "09", text: "Risques, interrogations et mitigations" },
];

let yPos = 0.95;
agendaItems.forEach((item) => {
  slide2.addShape(pres.shapes.OVAL, {
    x: 0.7, y: yPos, w: 0.4, h: 0.4,
    fill: { color: THEME.secondary }
  });
  slide2.addText(item.num, {
    x: 0.7, y: yPos, w: 0.4, h: 0.4,
    fontSize: 11, fontFace: THEME.fontBody, color: THEME.white,
    bold: true, align: "center", valign: "middle"
  });
  slide2.addText(item.text, {
    x: 1.25, y: yPos + 0.02, w: 7, h: 0.36,
    fontSize: 15, fontFace: THEME.fontBody, color: THEME.dark,
    valign: "middle"
  });
  yPos += 0.5;
});

// ============================================================================
// SLIDE 3 : CONTEXTE ET PÉRIMÈTRE
// ============================================================================

let slide3 = pres.addSlide();
slide3.background = { color: THEME.light };

slide3.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 0.12, h: 5.625,
  fill: { color: THEME.primary }
});

slide3.addText("Contexte et Périmètre", {
  x: 0.5, y: 0.3, w: 9, h: 0.65,
  fontSize: THEME.headingSize, fontFace: THEME.fontTitle, color: THEME.primary,
  bold: true, margin: 0
});

// Colonne gauche
slide3.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 0.95, w: 4.3, h: 3.5,
  fill: { color: THEME.white },
  shadow: { type: "outer", blur: 3, offset: 2, angle: 45, opacity: 0.2 }
});

slide3.addText("Périmètre Technique", {
  x: 0.7, y: 1.05, w: 4, h: 0.4,
  fontSize: 16, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide3.addText([
  { text: "Angular 5.2.0 → Angular 20", options: { bullet: true, breakLine: true } },
  { text: "2 343 composants identifiés", options: { bullet: true, breakLine: true } },
  { text: "500+ écrans applicatifs", options: { bullet: true, breakLine: true } },
  { text: "Librairie partagée (pwc-ui-shared)", options: { bullet: true, breakLine: true } },
  { text: "Application client (pwc-ui)", options: { bullet: true } }
], {
  x: 0.7, y: 1.5, w: 3.9, h: 1.6,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.dark,
  paraSpaceAfter: 5
});

// Chiffres
slide3.addShape(pres.shapes.RECTANGLE, {
  x: 0.7, y: 3.2, w: 1.8, h: 1.0,
  fill: { color: THEME.primary }
});
slide3.addText("2 343", {
  x: 0.7, y: 3.25, w: 1.8, h: 0.55,
  fontSize: 24, fontFace: THEME.fontTitle, color: THEME.white,
  bold: true, align: "center"
});
slide3.addText("composants", {
  x: 0.7, y: 3.8, w: 1.8, h: 0.3,
  fontSize: 10, fontFace: THEME.fontBody, color: THEME.accent,
  align: "center"
});

slide3.addShape(pres.shapes.RECTANGLE, {
  x: 2.7, y: 3.2, w: 1.8, h: 1.0,
  fill: { color: THEME.secondary }
});
slide3.addText("500+", {
  x: 2.7, y: 3.25, w: 1.8, h: 0.55,
  fontSize: 24, fontFace: THEME.fontTitle, color: THEME.white,
  bold: true, align: "center"
});
slide3.addText("écrans", {
  x: 2.7, y: 3.8, w: 1.8, h: 0.3,
  fontSize: 10, fontFace: THEME.fontBody, color: THEME.light,
  align: "center"
});

// Colonne droite
slide3.addShape(pres.shapes.RECTANGLE, {
  x: 5.1, y: 0.95, w: 4.3, h: 3.5,
  fill: { color: THEME.white },
  shadow: { type: "outer", blur: 3, offset: 2, angle: 45, opacity: 0.2 }
});

slide3.addText("Enjeux et Motivations", {
  x: 5.3, y: 1.05, w: 4, h: 0.4,
  fontSize: 16, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide3.addText([
  { text: "Fin de support Angular 5 (sécurité)", options: { bullet: true, breakLine: true } },
  { text: "Performance et maintenabilité", options: { bullet: true, breakLine: true } },
  { text: "Compatibilité navigateurs modernes", options: { bullet: true, breakLine: true } },
  { text: "Productivité des développeurs", options: { bullet: true, breakLine: true } },
  { text: "Conformité réglementaire", options: { bullet: true } }
], {
  x: 5.3, y: 1.5, w: 3.9, h: 1.6,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.dark,
  paraSpaceAfter: 5
});

slide3.addShape(pres.shapes.RECTANGLE, {
  x: 5.3, y: 3.2, w: 3.9, h: 1.0,
  fill: { color: THEME.success }
});
slide3.addText("Durée estimée : 3-4 mois", {
  x: 5.3, y: 3.35, w: 3.9, h: 0.4,
  fontSize: 16, fontFace: THEME.fontBody, color: THEME.white,
  bold: true, align: "center"
});
slide3.addText("Migration incrémentale par paliers", {
  x: 5.3, y: 3.75, w: 3.9, h: 0.35,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.light,
  align: "center"
});

// ============================================================================
// SLIDE 4 : APPROCHE SÉCURISÉE - FORK (séparé)
// ============================================================================

let slide4 = pres.addSlide();
slide4.background = { color: THEME.light };

slide4.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 0.12, h: 5.625,
  fill: { color: THEME.primary }
});

slide4.addText("Approche Sécurisée : Travail sur Fork", {
  x: 0.5, y: 0.3, w: 9, h: 0.65,
  fontSize: 26, fontFace: THEME.fontTitle, color: THEME.primary,
  bold: true, margin: 0
});

slide4.addText("Pourquoi travailler sur un fork ?", {
  x: 0.5, y: 0.95, w: 9, h: 0.3,
  fontSize: 15, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide4.addText("Un fork des deux repositories a été créé pour mettre au point le mode opératoire en toute sécurité, sans impacter l'environnement de production. Une fois le processus validé et documenté, la migration sera appliquée sur les repos officiels.", {
  x: 0.5, y: 1.25, w: 9, h: 0.55,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.gray
});

// Schéma fork
slide4.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 1.9, w: 4.2, h: 2.0,
  fill: { color: THEME.white },
  shadow: { type: "outer", blur: 3, offset: 2, angle: 45, opacity: 0.15 }
});
slide4.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 1.9, w: 0.07, h: 2.0,
  fill: { color: THEME.secondary }
});
slide4.addText("Repos Originaux (Production)", {
  x: 0.7, y: 2.0, w: 3.8, h: 0.35,
  fontSize: 14, fontFace: THEME.fontBody, color: THEME.primary, bold: true
});
slide4.addText([
  { text: "pwc-ui-shared", options: { bullet: true, breakLine: true } },
  { text: "pwc-ui", options: { bullet: true, breakLine: true } },
  { text: "→ Non modifiés pendant les tests", options: { color: THEME.gray, breakLine: true } },
  { text: "→ Protégés de toute régression", options: { color: THEME.gray } }
], {
  x: 0.7, y: 2.4, w: 3.8, h: 1.4,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.dark,
  paraSpaceAfter: 3
});

slide4.addText("FORK →", {
  x: 4.7, y: 2.6, w: 0.8, h: 0.5,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.secondary,
  bold: true, align: "center", valign: "middle"
});

slide4.addShape(pres.shapes.RECTANGLE, {
  x: 5.5, y: 1.9, w: 4.0, h: 2.0,
  fill: { color: THEME.white },
  shadow: { type: "outer", blur: 3, offset: 2, angle: 45, opacity: 0.15 }
});
slide4.addShape(pres.shapes.RECTANGLE, {
  x: 5.5, y: 1.9, w: 0.07, h: 2.0,
  fill: { color: THEME.success }
});
slide4.addText("Repos Fork (Environnement IA)", {
  x: 5.7, y: 2.0, w: 3.6, h: 0.35,
  fontSize: 14, fontFace: THEME.fontBody, color: THEME.success, bold: true
});
slide4.addText([
  { text: "pwc-ui-shared-v4-ia", options: { bullet: true, breakLine: true } },
  { text: "pwc-ui-v4-ia", options: { bullet: true, breakLine: true } },
  { text: "→ Tests, codemods, documentation", options: { color: THEME.gray, breakLine: true } },
  { text: "→ Élaboration du mode opératoire", options: { color: THEME.gray } }
], {
  x: 5.7, y: 2.4, w: 3.6, h: 1.4,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.dark,
  paraSpaceAfter: 3
});

// Note importante
slide4.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 4.1, w: 9, h: 0.7,
  fill: { color: "D1FAE5" }
});
slide4.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 4.1, w: 0.07, h: 0.7,
  fill: { color: THEME.success }
});
slide4.addText("✓  Une fois le mode opératoire validé sur le fork, il sera rejoué à l'identique sur les repos de production.", {
  x: 0.7, y: 4.15, w: 8.6, h: 0.6,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.success,
  valign: "middle"
});

// Avantage sécurité
slide4.addText("Avantages de cette approche", {
  x: 0.5, y: 4.95, w: 9, h: 0.25,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide4.addText("✓ Aucun risque sur la production     ✓ Tests en conditions réelles     ✓ Documentation au fil de l'eau     ✓ Rollback facile si besoin", {
  x: 0.5, y: 5.2, w: 9, h: 0.3,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.success
});

// ============================================================================
// SLIDE 5 : MODE OPÉRATOIRE ET CODEMODS (nouveau)
// ============================================================================

let slide5 = pres.addSlide();
slide5.background = { color: THEME.light };

slide5.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 0.12, h: 5.625,
  fill: { color: THEME.primary }
});

slide5.addText("Mode Opératoire et Codemods", {
  x: 0.5, y: 0.3, w: 9, h: 0.65,
  fontSize: THEME.headingSize, fontFace: THEME.fontTitle, color: THEME.primary,
  bold: true, margin: 0
});

// Qu'est-ce qu'un codemod
slide5.addText("Migration automatisée par logiciel, pas « à la main »", {
  x: 0.5, y: 0.95, w: 9, h: 0.3,
  fontSize: 15, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide5.addText("Un codemod est un script qui transforme automatiquement le code source. Il analyse l'AST (Abstract Syntax Tree) et applique des modifications cohérentes sur des milliers de fichiers en quelques secondes, là où un humain mettrait des jours avec des risques d'erreur.", {
  x: 0.5, y: 1.25, w: 9, h: 0.55,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.gray
});

// Exemple concret
slide5.addText("Exemple concret : migration RxJS 5 → 6", {
  x: 0.5, y: 1.9, w: 9, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

// Before
slide5.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 2.25, w: 4.3, h: 1.1,
  fill: { color: "FEE2E2" }
});
slide5.addText("AVANT (Angular 5)", {
  x: 0.6, y: 2.3, w: 4.1, h: 0.25,
  fontSize: 10, fontFace: THEME.fontBody, color: THEME.danger, bold: true
});
slide5.addText([
  { text: "import { Observable } from", options: { breakLine: true } },
  { text: "  'rxjs/Observable';", options: { breakLine: true } },
  { text: "import { map } from", options: { breakLine: true } },
  { text: "  'rxjs/operators/map';", options: {} }
], {
  x: 0.6, y: 2.55, w: 4.1, h: 0.75,
  fontSize: 10, fontFace: "Consolas", color: THEME.dark,
  paraSpaceAfter: 0
});

// Flèche
slide5.addText("codemod →", {
  x: 4.8, y: 2.55, w: 0.8, h: 0.5,
  fontSize: 10, fontFace: THEME.fontBody, color: THEME.secondary,
  bold: true, align: "center", valign: "middle"
});

// After
slide5.addShape(pres.shapes.RECTANGLE, {
  x: 5.5, y: 2.25, w: 4.0, h: 1.1,
  fill: { color: "D1FAE5" }
});
slide5.addText("APRÈS (Angular 6+)", {
  x: 5.6, y: 2.3, w: 3.8, h: 0.25,
  fontSize: 10, fontFace: THEME.fontBody, color: THEME.success, bold: true
});
slide5.addText([
  { text: "import { Observable } from", options: { breakLine: true } },
  { text: "  'rxjs';", options: { breakLine: true } },
  { text: "import { map } from", options: { breakLine: true } },
  { text: "  'rxjs/operators';", options: {} }
], {
  x: 5.6, y: 2.55, w: 3.8, h: 0.75,
  fontSize: 10, fontFace: "Consolas", color: THEME.dark,
  paraSpaceAfter: 0
});

// Applicabilité
slide5.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 3.5, w: 9, h: 0.65,
  fill: { color: "FEF3C7" }
});
slide5.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 3.5, w: 0.07, h: 0.65,
  fill: { color: THEME.warning }
});
slide5.addText("💡  Réutilisable sur tous les projets : ce mode opératoire pourra être appliqué à toutes les versions de nos écrans sur les différents projets, avec plus ou moins de customisation selon les spécificités.", {
  x: 0.7, y: 3.55, w: 8.6, h: 0.55,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.dark,
  valign: "middle"
});

// Les 5 étapes du MODOP
slide5.addText("Les 5 étapes du Mode Opératoire (MODOP)", {
  x: 0.5, y: 4.3, w: 9, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

const modopSteps = [
  { step: "1", text: "Tester chaque palier" },
  { step: "2", text: "Documenter les commandes" },
  { step: "3", text: "Valider les codemods" },
  { step: "4", text: "Créer checkpoints" },
  { step: "5", text: "Appliquer sur prod" },
];

let xModop = 0.5;
modopSteps.forEach((m, idx) => {
  const isLast = idx === 4;
  slide5.addShape(pres.shapes.RECTANGLE, {
    x: xModop, y: 4.65, w: 1.8, h: 0.75,
    fill: { color: isLast ? THEME.success : THEME.white },
    line: { color: isLast ? THEME.success : THEME.accent, width: 1 }
  });
  slide5.addText(m.step, {
    x: xModop, y: 4.65, w: 1.8, h: 0.3,
    fontSize: 13, fontFace: THEME.fontBody, color: isLast ? THEME.white : THEME.secondary,
    bold: true, align: "center"
  });
  slide5.addText(m.text, {
    x: xModop + 0.05, y: 4.95, w: 1.7, h: 0.4,
    fontSize: 9, fontFace: THEME.fontBody, color: isLast ? THEME.light : THEME.dark,
    align: "center"
  });
  if (idx < 4) {
    slide5.addText("→", {
      x: xModop + 1.75, y: 4.85, w: 0.2, h: 0.4,
      fontSize: 14, fontFace: THEME.fontBody, color: THEME.gray,
      align: "center", valign: "middle"
    });
  }
  xModop += 1.9;
});

// ============================================================================
// SLIDE 6 : CONFIGURATION POSTE DE TRAVAIL
// ============================================================================

let slide6 = pres.addSlide();
slide6.background = { color: THEME.light };

slide6.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 0.12, h: 5.625,
  fill: { color: THEME.primary }
});

slide6.addText("Configuration du Poste de Travail", {
  x: 0.5, y: 0.3, w: 9, h: 0.65,
  fontSize: THEME.headingSize, fontFace: THEME.fontTitle, color: THEME.primary,
  bold: true, margin: 0
});

// Problématique
slide6.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 0.95, w: 9, h: 0.7,
  fill: { color: "FEE2E2" }
});
slide6.addText("Contrainte : Pas de droits administrateur sur le poste", {
  x: 0.7, y: 1.0, w: 8.6, h: 0.3,
  fontSize: 14, fontFace: THEME.fontBody, color: THEME.danger, bold: true
});
slide6.addText("Chaque version d'Angular nécessite une version spécifique de Node.js. Solution : installations portables et scripts PowerShell personnalisés.", {
  x: 0.7, y: 1.3, w: 8.6, h: 0.3,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.dark
});

// Matrice versions
slide6.addText("Matrice Node.js / Angular", {
  x: 0.5, y: 1.75, w: 4.5, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide6.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 2.05, w: 4.5, h: 0.35,
  fill: { color: THEME.primary }
});
slide6.addText("Angular", { x: 0.6, y: 2.05, w: 1.3, h: 0.35, fontSize: 10, fontFace: THEME.fontBody, color: THEME.white, bold: true, valign: "middle" });
slide6.addText("Node.js", { x: 2.0, y: 2.05, w: 1.0, h: 0.35, fontSize: 10, fontFace: THEME.fontBody, color: THEME.white, bold: true, valign: "middle" });
slide6.addText("Commande", { x: 3.1, y: 2.05, w: 1.8, h: 0.35, fontSize: 10, fontFace: THEME.fontBody, color: THEME.white, bold: true, valign: "middle" });

const nodeVersions = [
  { angular: "5 - 8", node: "10.x", cmd: "Use-Node10", current: true },
  { angular: "9 - 11", node: "12.x", cmd: "Use-Node12", current: false },
  { angular: "12", node: "14.x", cmd: "Use-Node14", current: false },
  { angular: "13 - 14", node: "16.x", cmd: "Use-Node16", current: false },
  { angular: "15 - 17", node: "18.x", cmd: "Use-Node18", current: false },
  { angular: "18 - 20", node: "20.x", cmd: "Use-Node20", current: false },
];

let yNode = 2.4;
nodeVersions.forEach((v, idx) => {
  const bgColor = v.current ? "FEF3C7" : (idx % 2 === 0 ? THEME.white : "F8FAFC");
  slide6.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: yNode, w: 4.5, h: 0.32, fill: { color: bgColor } });
  slide6.addText(v.angular, { x: 0.6, y: yNode, w: 1.3, h: 0.32, fontSize: 10, fontFace: THEME.fontBody, color: THEME.dark, valign: "middle" });
  slide6.addText(v.node, { x: 2.0, y: yNode, w: 1.0, h: 0.32, fontSize: 10, fontFace: THEME.fontBody, color: THEME.dark, valign: "middle" });
  slide6.addText(v.cmd, { x: 3.1, y: yNode, w: 1.8, h: 0.32, fontSize: 9, fontFace: "Consolas", color: THEME.secondary, valign: "middle" });
  yNode += 0.32;
});

slide6.addText("■ Point de départ (Angular 5)", { x: 0.5, y: yNode + 0.05, w: 3, h: 0.25, fontSize: 9, fontFace: THEME.fontBody, color: THEME.warning });

// Solution PowerShell
slide6.addText("Solution : DevKit PowerShell", {
  x: 5.3, y: 1.75, w: 4.2, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide6.addShape(pres.shapes.RECTANGLE, {
  x: 5.3, y: 2.05, w: 4.2, h: 2.6,
  fill: { color: THEME.dark }
});

slide6.addText("vibecoding_powershell_devkit.ps1", {
  x: 5.4, y: 2.1, w: 4.0, h: 0.25,
  fontSize: 9, fontFace: "Consolas", color: THEME.accent
});

slide6.addText([
  { text: "# Changer de version Node.js", options: { color: THEME.gray, breakLine: true } },
  { text: "Use-Node10   # Pour Angular 5-8", options: { color: THEME.light, breakLine: true } },
  { text: "Use-Node12   # Pour Angular 9-11", options: { color: THEME.light, breakLine: true } },
  { text: "Use-Node18   # Pour Angular 15+", options: { color: THEME.light, breakLine: true } },
  { text: "", options: { breakLine: true } },
  { text: "# Vérifier version active", options: { color: THEME.gray, breakLine: true } },
  { text: "node-version", options: { color: THEME.light, breakLine: true } },
  { text: "", options: { breakLine: true } },
  { text: "# Diagnostic complet stack", options: { color: THEME.gray, breakLine: true } },
  { text: ".\\check-stack.ps1", options: { color: THEME.light } }
], {
  x: 5.4, y: 2.4, w: 4.0, h: 2.2,
  fontSize: 9, fontFace: "Consolas",
  paraSpaceAfter: 0
});

// Avantages
slide6.addText("Avantages", {
  x: 0.5, y: 4.85, w: 9, h: 0.25,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide6.addText("✓ Aucun droit admin requis     ✓ Changement instantané     ✓ Versions en parallèle     ✓ Reproductible", {
  x: 0.5, y: 5.1, w: 9, h: 0.3,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.success
});

// ============================================================================
// SLIDE 7 : STRATÉGIE PAR PALIERS
// ============================================================================

let slide7 = pres.addSlide();
slide7.background = { color: THEME.light };

slide7.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 0.12, h: 5.625,
  fill: { color: THEME.primary }
});

slide7.addText("Stratégie de Migration par Paliers", {
  x: 0.5, y: 0.3, w: 9, h: 0.65,
  fontSize: THEME.headingSize, fontFace: THEME.fontTitle, color: THEME.primary,
  bold: true, margin: 0
});

slide7.addText("Migration directe v5→v20 impossible : chaque version majeure a des breaking changes. L'approche par paliers permet de valider chaque étape.", {
  x: 0.5, y: 0.95, w: 9, h: 0.4,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.gray
});

// Timeline
const paliers = [
  { version: "5→6", label: "RxJS 6", color: THEME.success },
  { version: "6→8", label: "ViewChild", color: THEME.secondary },
  { version: "8→12", label: "Ivy", color: THEME.secondary },
  { version: "12→16", label: "Standalone", color: THEME.secondary },
  { version: "16→20", label: "Signals", color: THEME.secondary },
];

let xPal = 0.5;
paliers.forEach((p, idx) => {
  slide7.addShape(pres.shapes.RECTANGLE, {
    x: xPal, y: 1.45, w: 1.75, h: 0.8,
    fill: { color: p.color }
  });
  slide7.addText(`v${p.version}`, {
    x: xPal, y: 1.45, w: 1.75, h: 0.45,
    fontSize: 14, fontFace: THEME.fontBody, color: THEME.white,
    bold: true, align: "center", valign: "middle"
  });
  slide7.addText(p.label, {
    x: xPal, y: 1.85, w: 1.75, h: 0.35,
    fontSize: 10, fontFace: THEME.fontBody, color: THEME.light,
    align: "center"
  });
  if (idx < 4) {
    slide7.addText("→", {
      x: xPal + 1.7, y: 1.6, w: 0.2, h: 0.4,
      fontSize: 14, fontFace: THEME.fontBody, color: THEME.gray,
      align: "center", valign: "middle"
    });
  }
  xPal += 1.9;
});

// Règle LIB avant CLIENT
slide7.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 2.4, w: 9, h: 0.75,
  fill: { color: THEME.primary }
});
slide7.addText("Règle fondamentale : LIB avant CLIENT", {
  x: 0.7, y: 2.45, w: 8.6, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.accent, bold: true
});
slide7.addText("La librairie partagée doit être migrée et validée AVANT l'application client. Le client dépend de la lib.", {
  x: 0.7, y: 2.75, w: 8.6, h: 0.35,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.light
});

// Workflow
slide7.addText("Workflow répété à chaque palier", {
  x: 0.5, y: 3.3, w: 9, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

const steps = ["Use-NodeXX", "ng update", "Codemods", "Build+Tests", "Commit", "Checkpoint"];
let xStep = 0.5;
steps.forEach((s, idx) => {
  slide7.addShape(pres.shapes.RECTANGLE, {
    x: xStep, y: 3.65, w: 1.45, h: 0.5,
    fill: { color: THEME.white },
    line: { color: THEME.accent, width: 1 }
  });
  slide7.addText(`${idx + 1}. ${s}`, {
    x: xStep, y: 3.65, w: 1.45, h: 0.5,
    fontSize: 9, fontFace: THEME.fontBody, color: THEME.primary,
    bold: true, align: "center", valign: "middle"
  });
  xStep += 1.55;
});

// Codemods développés
slide7.addText("4 codemods développés (évolutif)", {
  x: 0.5, y: 4.3, w: 9, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

const codemods = [
  { name: "rxjs-imports.js", usage: "v5→6" },
  { name: "viewchild-static.js", usage: "v7→8" },
  { name: "module-with-providers.js", usage: "v9→10" },
  { name: "console-to-logger.js", usage: "Tous" },
];

let xCm = 0.5;
codemods.forEach(c => {
  slide7.addShape(pres.shapes.RECTANGLE, {
    x: xCm, y: 4.65, w: 2.2, h: 0.7,
    fill: { color: THEME.dark }
  });
  slide7.addText(c.name, {
    x: xCm + 0.1, y: 4.7, w: 2.0, h: 0.35,
    fontSize: 9, fontFace: "Consolas", color: THEME.accent
  });
  slide7.addText(c.usage, {
    x: xCm + 0.1, y: 5.0, w: 2.0, h: 0.3,
    fontSize: 9, fontFace: THEME.fontBody, color: THEME.light
  });
  xCm += 2.3;
});

// ============================================================================
// SLIDE 8 : OUTILLAGE IA ET WORKFLOW STATEFUL
// ============================================================================

let slide8 = pres.addSlide();
slide8.background = { color: THEME.light };

slide8.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 0.12, h: 5.625,
  fill: { color: THEME.primary }
});

slide8.addText("Outillage IA et Workflow Stateful", {
  x: 0.5, y: 0.3, w: 9, h: 0.65,
  fontSize: THEME.headingSize, fontFace: THEME.fontTitle, color: THEME.primary,
  bold: true, margin: 0
});

// Kiro + Skills
slide8.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 0.95, w: 4.3, h: 2.0,
  fill: { color: THEME.white },
  shadow: { type: "outer", blur: 3, offset: 2, angle: 45, opacity: 0.15 }
});
slide8.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 0.95, w: 4.3, h: 0.06, fill: { color: THEME.accent } });

slide8.addText("Kiro AI + Skills", {
  x: 0.7, y: 1.05, w: 4, h: 0.3,
  fontSize: 14, fontFace: THEME.fontBody, color: THEME.primary, bold: true
});
slide8.addText([
  { text: "IDE IA avec contexte projet persistant", options: { bullet: true, breakLine: true } },
  { text: "Skills = modules d'expertise à la demande", options: { bullet: true, breakLine: true } },
  { text: "Workspace multi-projets (parent/enfants)", options: { bullet: true, breakLine: true } },
  { text: "Génération specs et tâches automatique", options: { bullet: true } }
], {
  x: 0.7, y: 1.4, w: 3.9, h: 1.4,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.dark,
  paraSpaceAfter: 3
});

// Strands
slide8.addShape(pres.shapes.RECTANGLE, {
  x: 5.1, y: 0.95, w: 4.4, h: 2.0,
  fill: { color: THEME.white },
  shadow: { type: "outer", blur: 3, offset: 2, angle: 45, opacity: 0.15 }
});
slide8.addShape(pres.shapes.RECTANGLE, { x: 5.1, y: 0.95, w: 4.4, h: 0.06, fill: { color: THEME.success } });

slide8.addText("Strands Agent : Workflow Stateful", {
  x: 5.3, y: 1.05, w: 4, h: 0.3,
  fontSize: 14, fontFace: THEME.fontBody, color: THEME.primary, bold: true
});
slide8.addText([
  { text: "État persisté entre sessions", options: { bullet: true, breakLine: true } },
  { text: "Checkpoints et rollback possibles", options: { bullet: true, breakLine: true } },
  { text: "Reprise exacte après interruption", options: { bullet: true, breakLine: true } },
  { text: "Orchestration automatique LIB→CLIENT", options: { bullet: true } }
], {
  x: 5.3, y: 1.4, w: 4.0, h: 1.4,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.dark,
  paraSpaceAfter: 3
});

// Schéma state
slide8.addText("Fonctionnement du Workflow Stateful", {
  x: 0.5, y: 3.1, w: 9, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide8.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 3.45, w: 3.5, h: 1.9,
  fill: { color: THEME.dark }
});
slide8.addText("strands-state.json", {
  x: 0.6, y: 3.5, w: 3.3, h: 0.25,
  fontSize: 9, fontFace: "Consolas", color: THEME.accent
});
slide8.addText([
  { text: "{", options: { breakLine: true } },
  { text: '  "currentPhase": "5→6",', options: { breakLine: true } },
  { text: '  "libStatus": "completed",', options: { breakLine: true } },
  { text: '  "clientStatus": "pending",', options: { breakLine: true } },
  { text: '  "checkpoints": [...]', options: { breakLine: true } },
  { text: "}", options: {} }
], {
  x: 0.6, y: 3.8, w: 3.3, h: 1.5,
  fontSize: 9, fontFace: "Consolas", color: THEME.light,
  paraSpaceAfter: 0
});

slide8.addText("→", {
  x: 4.0, y: 4.1, w: 0.4, h: 0.5,
  fontSize: 24, fontFace: THEME.fontBody, color: THEME.secondary,
  align: "center", valign: "middle"
});

// Commandes
slide8.addShape(pres.shapes.RECTANGLE, {
  x: 4.5, y: 3.45, w: 5.0, h: 1.9,
  fill: { color: THEME.white },
  shadow: { type: "outer", blur: 3, offset: 2, angle: 45, opacity: 0.15 }
});
slide8.addText("Commandes disponibles", {
  x: 4.7, y: 3.55, w: 4.6, h: 0.3,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.primary, bold: true
});

const cmds = [
  { cmd: "#strands status", desc: "Voir l'état actuel" },
  { cmd: "#strands resume", desc: "Reprendre après interruption" },
  { cmd: "#strands rollback", desc: "Revenir à un checkpoint" },
  { cmd: "#strands checkpoint", desc: "Créer point de sauvegarde" },
];
let yCmd = 3.9;
cmds.forEach(c => {
  slide8.addText(c.cmd, { x: 4.7, y: yCmd, w: 2.2, h: 0.32, fontSize: 10, fontFace: "Consolas", color: THEME.secondary });
  slide8.addText(c.desc, { x: 6.9, y: yCmd, w: 2.4, h: 0.32, fontSize: 10, fontFace: THEME.fontBody, color: THEME.gray });
  yCmd += 0.35;
});

// ============================================================================
// SLIDE 9 : JOURNAL DE BORD
// ============================================================================

let slide9 = pres.addSlide();
slide9.background = { color: THEME.light };

slide9.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 0.12, h: 5.625,
  fill: { color: THEME.primary }
});

slide9.addText("Journal de Bord et Traçabilité", {
  x: 0.5, y: 0.3, w: 9, h: 0.65,
  fontSize: THEME.headingSize, fontFace: THEME.fontTitle, color: THEME.primary,
  bold: true, margin: 0
});

slide9.addText("Pourquoi un journal de bord ?", {
  x: 0.5, y: 0.95, w: 9, h: 0.3,
  fontSize: 14, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide9.addText("La migration s'étale sur 3-4 mois avec de nombreuses actions. Un journal de bord permet de tracer chaque action avec sa date, les versions impliquées, et les résultats. Essentiel pour la reproductibilité et l'audit.", {
  x: 0.5, y: 1.25, w: 9, h: 0.5,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.gray
});

// Structure du journal
slide9.addText("Structure du journal", {
  x: 0.5, y: 1.8, w: 4.5, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide9.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 2.1, w: 4.5, h: 2.8,
  fill: { color: THEME.dark }
});

slide9.addText("JOURNAL-MIGRATION.md", {
  x: 0.6, y: 2.15, w: 4.3, h: 0.25,
  fontSize: 9, fontFace: "Consolas", color: THEME.accent
});

slide9.addText([
  { text: "## 2026-01-28 - Initialisation", options: { color: THEME.accent, breakLine: true } },
  { text: "- Fork des repos créé", options: { color: THEME.light, breakLine: true } },
  { text: "- Angular: 5.2.0 | Node: 10.24.1", options: { color: THEME.gray, breakLine: true } },
  { text: "", options: { breakLine: true } },
  { text: "## 2026-01-30 - Outillage", options: { color: THEME.accent, breakLine: true } },
  { text: "- Config Kiro workspace", options: { color: THEME.light, breakLine: true } },
  { text: "- 4 codemods développés", options: { color: THEME.light, breakLine: true } },
  { text: "- Scripts check-stack.ps1", options: { color: THEME.light, breakLine: true } },
  { text: "", options: { breakLine: true } },
  { text: "## 2026-02-xx - Palier 5→6", options: { color: THEME.accent, breakLine: true } },
  { text: "- [À venir]", options: { color: THEME.gray } }
], {
  x: 0.6, y: 2.45, w: 4.3, h: 2.4,
  fontSize: 9, fontFace: "Consolas",
  paraSpaceAfter: 0
});

// Contenu tracé
slide9.addText("Informations tracées", {
  x: 5.3, y: 1.8, w: 4.2, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

const trackedInfo = [
  { icon: "📅", text: "Date de chaque action" },
  { icon: "🔢", text: "Versions (Angular, Node, RxJS, TS)" },
  { icon: "⚡", text: "Commandes exécutées" },
  { icon: "✅", text: "Résultats (succès/échec)" },
  { icon: "🔖", text: "Checkpoints créés" },
  { icon: "⚠️", text: "Problèmes et solutions" },
  { icon: "📝", text: "Décisions et justifications" },
];

let yTrack = 2.15;
trackedInfo.forEach(t => {
  slide9.addShape(pres.shapes.RECTANGLE, {
    x: 5.3, y: yTrack, w: 4.2, h: 0.36,
    fill: { color: THEME.white },
    line: { color: "E2E8F0", width: 1 }
  });
  slide9.addText(`${t.icon}  ${t.text}`, {
    x: 5.45, y: yTrack, w: 3.9, h: 0.36,
    fontSize: 10, fontFace: THEME.fontBody, color: THEME.dark,
    valign: "middle"
  });
  yTrack += 0.38;
});

// Bénéfices
slide9.addText("Bénéfices", {
  x: 0.5, y: 5.05, w: 9, h: 0.25,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});
slide9.addText("✓ Reproductibilité     ✓ Audit trail     ✓ Facilite passage en prod     ✓ Onboarding", {
  x: 0.5, y: 5.3, w: 9, h: 0.25,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.success
});

// ============================================================================
// SLIDE 10 : ÉTAT D'AVANCEMENT
// ============================================================================

let slide10 = pres.addSlide();
slide10.background = { color: THEME.light };

slide10.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 0.12, h: 5.625,
  fill: { color: THEME.primary }
});

slide10.addText("État d'Avancement", {
  x: 0.5, y: 0.3, w: 9, h: 0.65,
  fontSize: THEME.headingSize, fontFace: THEME.fontTitle, color: THEME.primary,
  bold: true, margin: 0
});

// Phase actuelle
slide10.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 0.95, w: 2.8, h: 1.8,
  fill: { color: THEME.primary }
});
slide10.addText("PHASE", {
  x: 0.5, y: 1.05, w: 2.8, h: 0.3,
  fontSize: 10, fontFace: THEME.fontBody, color: THEME.accent,
  align: "center"
});
slide10.addText("Préparation", {
  x: 0.5, y: 1.35, w: 2.8, h: 0.6,
  fontSize: 22, fontFace: THEME.fontTitle, color: THEME.white,
  bold: true, align: "center", valign: "middle"
});
slide10.addText("Outillage & Config", {
  x: 0.5, y: 2.05, w: 2.8, h: 0.4,
  fontSize: 10, fontFace: THEME.fontBody, color: THEME.light,
  align: "center"
});

// Réalisé
slide10.addText("Réalisé", {
  x: 3.5, y: 0.95, w: 6, h: 0.3,
  fontSize: 14, fontFace: THEME.fontBody, color: THEME.success, bold: true
});

const done = [
  "Fork des 2 repos (pwc-ui-shared-v4-ia, pwc-ui-v4-ia)",
  "Analyse complète : 2343 composants identifiés",
  "Configuration Kiro workspace multi-projets (évolutif)",
  "Développement des 4 codemods de migration (évolutif)",
  "Scripts PowerShell (check-stack, install-dependencies)",
  "Documentation technique (MODOP, évolutif)"
];

slide10.addText(done.map((t, i) => ({
  text: `✓  ${t}`,
  options: { breakLine: i < done.length - 1, color: THEME.success }
})), {
  x: 3.5, y: 1.25, w: 6, h: 1.5,
  fontSize: 11, fontFace: THEME.fontBody,
  paraSpaceAfter: 3
});

// En cours + À faire
slide10.addText("En cours", {
  x: 0.5, y: 2.9, w: 4.5, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.warning, bold: true
});
slide10.addText([
  { text: "○  Validation héritage Kiro parent/enfant", options: { breakLine: true, color: THEME.warning } },
  { text: "○  Installation et test Strands Agent", options: { breakLine: true, color: THEME.warning } },
  { text: "○  Mise en place journal de bord", options: { color: THEME.warning } }
], {
  x: 0.5, y: 3.2, w: 4.5, h: 0.8,
  fontSize: 11, fontFace: THEME.fontBody,
  paraSpaceAfter: 3
});

slide10.addText("Prochaines étapes", {
  x: 5.3, y: 2.9, w: 4.2, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});
slide10.addText([
  { text: "→  Lancer migration v5→6 sur LIB", options: { breakLine: true, color: THEME.dark } },
  { text: "→  Exécuter codemod rxjs-imports.js", options: { breakLine: true, color: THEME.dark } },
  { text: "→  Valider build et tests", options: { color: THEME.dark } }
], {
  x: 5.3, y: 3.2, w: 4.2, h: 0.8,
  fontSize: 11, fontFace: THEME.fontBody,
  paraSpaceAfter: 3
});

// Timeline
slide10.addText("Planning estimé (3-4 mois)", {
  x: 0.5, y: 4.15, w: 9, h: 0.3,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

const phases = [
  { name: "Prépa", pct: 15, status: "current" },
  { name: "v5→8", pct: 25, status: "todo" },
  { name: "v8→12", pct: 25, status: "todo" },
  { name: "v12→16", pct: 20, status: "todo" },
  { name: "v16→20", pct: 15, status: "todo" },
];

let xPhase = 0.5;
phases.forEach(p => {
  const w = (9 * p.pct) / 100;
  const bg = p.status === "current" ? THEME.success : "E2E8F0";
  const txt = p.status === "current" ? THEME.white : THEME.gray;
  slide10.addShape(pres.shapes.RECTANGLE, { x: xPhase, y: 4.5, w: w, h: 0.45, fill: { color: bg } });
  slide10.addText(p.name, { x: xPhase, y: 4.5, w: w, h: 0.45, fontSize: 10, fontFace: THEME.fontBody, color: txt, bold: p.status === "current", align: "center", valign: "middle" });
  xPhase += w;
});

slide10.addText("■ Phase actuelle (75% terminée)", {
  x: 0.5, y: 5.0, w: 4, h: 0.25,
  fontSize: 10, fontFace: THEME.fontBody, color: THEME.success
});

// Note bouchons
slide10.addShape(pres.shapes.RECTANGLE, {
  x: 4.7, y: 4.95, w: 4.8, h: 0.55,
  fill: { color: "FEF3C7" }
});
slide10.addText("💡 Tests en bac de prod : prévoir des bouchons pour les inputs non disponibles", {
  x: 4.8, y: 5.0, w: 4.6, h: 0.45,
  fontSize: 9, fontFace: THEME.fontBody, color: THEME.warning,
  valign: "middle"
});

// ============================================================================
// SLIDE 11 : RISQUES ET INTERROGATIONS
// ============================================================================

let slide11 = pres.addSlide();
slide11.background = { color: THEME.light };

slide11.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 0, w: 0.12, h: 5.625,
  fill: { color: THEME.primary }
});

slide11.addText("Risques, Interrogations et Mitigations", {
  x: 0.5, y: 0.3, w: 9, h: 0.65,
  fontSize: 25, fontFace: THEME.fontTitle, color: THEME.primary,
  bold: true, margin: 0
});

slide11.addText("Risques identifiés", {
  x: 0.5, y: 0.95, w: 9, h: 0.3,
  fontSize: 13, fontFace: THEME.fontBody, color: THEME.secondary, bold: true
});

slide11.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 1.25, w: 9, h: 0.35, fill: { color: THEME.primary } });
slide11.addText("Risque", { x: 0.6, y: 1.25, w: 2.8, h: 0.35, fontSize: 11, fontFace: THEME.fontBody, color: THEME.white, bold: true, valign: "middle" });
slide11.addText("Impact", { x: 3.5, y: 1.25, w: 0.8, h: 0.35, fontSize: 11, fontFace: THEME.fontBody, color: THEME.white, bold: true, valign: "middle", align: "center" });
slide11.addText("Mitigation", { x: 4.4, y: 1.25, w: 5.0, h: 0.35, fontSize: 11, fontFace: THEME.fontBody, color: THEME.white, bold: true, valign: "middle" });

const risks = [
  { risk: "Régressions fonctionnelles", impact: "Élevé", mitigation: "Tests automatisés + validation par palier", color: THEME.danger },
  { risk: "Incompatibilités LIB/CLIENT", impact: "Élevé", mitigation: "Migration LIB first + build systématique", color: THEME.danger },
  { risk: "Délais dépassés", impact: "Moyen", mitigation: "Automatisation + checkpoints Strands", color: THEME.warning },
  { risk: "Perte de contexte équipe", impact: "Moyen", mitigation: "Journal de bord + état persisté", color: THEME.warning },
  { risk: "Inputs manquants en bac de prod", impact: "Moyen", mitigation: "Mise en place de bouchons (mocks)", color: THEME.warning },
];

let yRisk = 1.6;
risks.forEach((r, idx) => {
  const bg = idx % 2 === 0 ? THEME.white : "F8FAFC";
  slide11.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: yRisk, w: 9, h: 0.45, fill: { color: bg } });
  slide11.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: yRisk, w: 0.06, h: 0.45, fill: { color: r.color } });
  slide11.addText(r.risk, { x: 0.65, y: yRisk, w: 2.75, h: 0.45, fontSize: 10, fontFace: THEME.fontBody, color: THEME.dark, valign: "middle" });
  slide11.addText(r.impact, { x: 3.5, y: yRisk, w: 0.8, h: 0.45, fontSize: 10, fontFace: THEME.fontBody, color: r.color, bold: true, valign: "middle", align: "center" });
  slide11.addText(r.mitigation, { x: 4.4, y: yRisk, w: 5.0, h: 0.45, fontSize: 10, fontFace: THEME.fontBody, color: THEME.gray, valign: "middle" });
  yRisk += 0.45;
});

// INTERROGATION NEXUS
slide11.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 4.0, w: 9, h: 1.4,
  fill: { color: "FEF3C7" }
});
slide11.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 4.0, w: 0.08, h: 1.4,
  fill: { color: THEME.warning }
});

slide11.addText("⚠️  INTERROGATION : Gestion des node_modules avec Nexus", {
  x: 0.7, y: 4.1, w: 8.6, h: 0.3,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.warning, bold: true
});

slide11.addText([
  { text: "Problématique : ", options: { bold: true } },
  { text: "Les dépendances npm passent par le proxy Nexus corporate. Lors de la migration, les nouvelles versions des packages Angular devront être disponibles dans Nexus.", options: { breakLine: true, breakLine: true } },
  { text: "Questions ouvertes : ", options: { bold: true } },
  { text: "Comment mettre à jour les packages ? Processus de demande ? Contournement possible ?", options: {} }
], {
  x: 0.7, y: 4.4, w: 8.6, h: 0.9,
  fontSize: 10, fontFace: THEME.fontBody, color: THEME.dark,
  paraSpaceAfter: 2
});

// ============================================================================
// SLIDE 12 : QUESTIONS
// ============================================================================

let slide12 = pres.addSlide();
slide12.background = { color: THEME.primary };

slide12.addShape(pres.shapes.RECTANGLE, {
  x: 0, y: 5.475, w: 10, h: 0.15,
  fill: { color: THEME.accent }
});

slide12.addText("Questions ?", {
  x: 0.5, y: 1.3, w: 9, h: 0.9,
  fontSize: 52, fontFace: THEME.fontTitle, color: THEME.white,
  align: "center"
});

slide12.addText("Points clés à retenir", {
  x: 0.5, y: 2.5, w: 9, h: 0.4,
  fontSize: 17, fontFace: THEME.fontBody, color: THEME.accent,
  align: "center"
});

const keyPoints = [
  "Approche sécurisée : fork pour élaborer le MODOP, puis application en production",
  "Migration automatisée par codemods (pas « à la main »), réutilisable sur tous les projets",
  "Migration incrémentale par paliers (5 phases sur 3-4 mois)",
  "Outillage évolutif : codemods, Kiro AI, Strands (rien n'est figé)",
  "Traçabilité complète : journal de bord avec dates et versions",
  "Règle d'or : toujours LIB avant CLIENT",
  "Points ouverts : gestion Nexus + bouchons pour tests prod"
];

slide12.addText(keyPoints.map((t, i) => ({
  text: `${i + 1}. ${t}`,
  options: { breakLine: i < keyPoints.length - 1 }
})), {
  x: 0.8, y: 3.0, w: 8.4, h: 2.2,
  fontSize: 12, fontFace: THEME.fontBody, color: THEME.light,
  align: "left", paraSpaceAfter: 5
});

slide12.addText(AUTHOR, {
  x: 0.5, y: 5.15, w: 9, h: 0.25,
  fontSize: 11, fontFace: THEME.fontBody, color: THEME.gray,
  align: "center"
});

// ============================================================================
// EXPORT
// ============================================================================

const fileName = "Migration-Angular-5-20-v3.4-2fev26.pptx";
pres.writeFile({ fileName: `/mnt/user-data/outputs/${fileName}` })
  .then(() => console.log(`✅ Présentation créée : ${fileName}`))
  .catch(err => console.error("❌ Erreur:", err));