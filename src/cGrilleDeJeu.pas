/// <summary>
/// ***************************************************************************
///
/// Colblor
///
/// Copyright 2021-2025 Patrick PREMARTIN under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://colblor.gamolf.fr
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Colblor
///
/// ***************************************************************************
/// File last update : 2025-03-30T17:53:52.000+02:00
/// Signature : 85292151f1d0c99d8690c1374f0cf8ed72bafd3e
/// ***************************************************************************
/// </summary>

unit cGrilleDeJeu;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  fAncetreCadreTraduit,
  uInfosPartieEnCours,
  FMX.Layouts,
  FMX.Objects,
  System.Generics.Collections;

const
  CNbCol = 10;
  CNbLig = 10;

type
  TCase = record
    rect: TRectangle;
    couleur: TCouleurDesCases;
  end;

  TCases = array [0 .. (CNbCol - 1), 0 .. (CNbLig - 1)] of TCase;

  TGrilleDeJeu = class(T_AncetreCadreTraduit)
    GrilleAffichee: TGridPanelLayout;
    CadreDeLaGrille: TRectangle;
    procedure FrameResize(Sender: TObject);
  public
    grille: TCases;
    /// <summary>
    /// Calcule la taille des éléménts de jeu en fonction des besoins
    /// </summary>
    procedure InitialiserLaGrille;
    /// <summary>
    /// Vider pour remplir la grille de jeu de façon aléatoire
    /// </summary>
    procedure RemplirLaGrille(CouleurAleatoire: boolean = true);
    procedure RemplirLaGrilleDepuisGrilleTournoi;
    /// <summary>
    /// Calcul des dimensions au moment de l'affichage et affichage des cases si elles ne le sont pas encore
    /// </summary>
    procedure AfficherLaGrille;
    /// <summary>
    /// Retourne la couleur la plus représentée actuellement dans la grille
    /// </summary>
    function CouleurLaPlusUtilisee: TCouleurDesCases;
    /// <summary>
    /// choisi une couleur au hasard dans celles qui sont utilisées par la grille
    /// </summary>
    function CouleurAuHasard: TCouleurDesCases;
    /// <summary>
    /// Retourne la couleur la moins utilisée dans la grille
    /// </summary>
    function CouleurLaMoinsUtilisee: TCouleurDesCases;
    /// <summary>
    /// Remplace la couleur demandée par l'autre s'il y a des cases adjacentes
    /// </summary>
    procedure Bascule(CouleurDepart, CouleurDestination: TCouleurDesCases);
    /// <summary>
    /// Regarde si plusieurs couleurs différentes sopnt disponibles dans la grille
    /// </summary>
    function hasPlusieursCouleurs: boolean;
    /// <summary>
    /// Retourne la couleur utilisable par Delphi à partir d'une couleur définie dans le code
    /// </summary>
    function getAlphaColorFromCouleur(couleur: TCouleurDesCases): talphacolor;
    /// <summary>
    /// Prépare les infos de la grille et son contenu (affiché et matrice de traitement)
    /// </summary>
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  System.Math,
  uTournoiAPI;

type
  TNbCouleurList = TDictionary<TCouleurDesCases, integer>;

  { TGrilleDeJeu }

procedure TGrilleDeJeu.AfficherLaGrille;
var
  TailleDeLaGrille: single;
begin
  TailleDeLaGrille := min(width - 10, height - 10);
  GrilleAffichee.Size.Size := pointf(TailleDeLaGrille, TailleDeLaGrille);
  CadreDeLaGrille.Size.Size := pointf(GrilleAffichee.width + 10,
    GrilleAffichee.height + 10);
end;

procedure TGrilleDeJeu.Bascule(CouleurDepart, CouleurDestination
  : TCouleurDesCases);

// TODO : la version récursive oublie des cases, ou en parcourt trop. Faudrait savoir d'où on vient pour ne pas y retourner.
// function TesteEtChangeCouleur(col, lig: integer): boolean;
// begin
// result := false;
// if (grille[col, lig].couleur = CouleurDepart) then
// begin
// if (col > 0) then
// if (grille[col - 1, lig].couleur = CouleurDestination) then
// result := result or true
// else if (grille[col - 1, lig].couleur = CouleurDepart) then
// result := result or TesteEtChangeCouleur(col - 1, lig);
// if (col < CNbCol - 1) then
// if (grille[col + 1, lig].couleur = CouleurDestination) then
// result := result or true
// else if (grille[col + 1, lig].couleur = CouleurDepart) then
// result := result or TesteEtChangeCouleur(col + 1, lig);
// if (lig > 0) then
// if (grille[col, lig - 1].couleur = CouleurDestination) then
// result := result or true
// else if (grille[col, lig - 1].couleur = CouleurDepart) then
// result := result or TesteEtChangeCouleur(col, lig - 1);
// if (lig < CNbLig - 1) then
// if (grille[col, lig + 1].couleur = CouleurDestination) then
// result := result or true
// else if (grille[col, lig + 1].couleur = CouleurDepart) then
// result := result or TesteEtChangeCouleur(col, lig + 1);
// if result then
// begin
// grille[col, lig].couleur := CouleurDestination;
// grille[col, lig].rect.fill.Color :=
// getAlphaColorFromCouleur(CouleurDestination);
// end;
// grille[col, lig].testee := true;
// end;
// end;

var
  i, j: integer;
  ModifFaite: boolean;
begin
  // for i := 0 to CNbCol - 1 do
  // for j := 0 to CNbLig - 1 do
  // TesteEtChangeCouleur(i, j);

  // Version non optimisée en temps de réponse mais fiable en terme de parcourt
  repeat
    ModifFaite := false;
    for i := 0 to CNbCol - 1 do
      for j := 0 to CNbLig - 1 do
        if (grille[i, j].couleur = CouleurDepart) and
          (((i > 0) and (grille[i - 1, j].couleur = CouleurDestination)) or
          ((j > 0) and (grille[i, j - 1].couleur = CouleurDestination)) or
          ((i < CNbCol - 1) and (grille[i + 1, j].couleur = CouleurDestination))
          or ((j < CNbLig - 1) and (grille[i,
          j + 1].couleur = CouleurDestination))) then
        begin
          ModifFaite := true;
          grille[i, j].couleur := CouleurDestination;
          grille[i, j].rect.fill.Color := getAlphaColorFromCouleur
            (CouleurDestination);
        end;
  until not ModifFaite;
end;

function TGrilleDeJeu.CouleurAuHasard: TCouleurDesCases;
begin
  result := grille[random(CNbCol), random(CNbLig)].couleur;
end;

function TGrilleDeJeu.CouleurLaMoinsUtilisee: TCouleurDesCases;
var
  i, j: integer;
  CouleurListe: TNbCouleurList;
  couleur: TCouleurDesCases;
  nb: integer;
begin
  result := TCouleurDesCases.Aucune;
  CouleurListe := TNbCouleurList.Create;
  try
    for i := 0 to CNbCol - 1 do
      for j := 0 to CNbLig - 1 do
        if CouleurListe.ContainsKey(grille[i, j].couleur) then
          CouleurListe[grille[i, j].couleur] :=
            CouleurListe[grille[i, j].couleur] + 1
        else
          CouleurListe.Add(grille[i, j].couleur, 1);
    nb := CNbCol * CNbLig;
    if (CouleurListe.Count > 0) then
      for couleur in CouleurListe.Keys do
        if (CouleurListe[couleur] < nb) then
        begin
          nb := CouleurListe[couleur];
          result := couleur;
        end;
  finally
    CouleurListe.free;
  end;
end;

function TGrilleDeJeu.CouleurLaPlusUtilisee: TCouleurDesCases;
var
  i, j: integer;
  CouleurListe: TNbCouleurList;
  couleur: TCouleurDesCases;
  nb: integer;
begin
  result := TCouleurDesCases.Aucune;
  CouleurListe := TNbCouleurList.Create;
  try
    for i := 0 to CNbCol - 1 do
      for j := 0 to CNbLig - 1 do
        if CouleurListe.ContainsKey(grille[i, j].couleur) then
          CouleurListe[grille[i, j].couleur] :=
            CouleurListe[grille[i, j].couleur] + 1
        else
          CouleurListe.Add(grille[i, j].couleur, 1);
    nb := 0;
    if (CouleurListe.Count > 0) then
      for couleur in CouleurListe.Keys do
        if (CouleurListe[couleur] > nb) then
        begin
          nb := CouleurListe[couleur];
          result := couleur;
        end;
  finally
    CouleurListe.free;
  end;
end;

constructor TGrilleDeJeu.Create(AOwner: TComponent);
var
  i, j: integer;
begin
  inherited;
  for i := 0 to CNbCol - 1 do
    for j := 0 to CNbLig - 1 do
    begin
      grille[i, j].rect := nil;
      grille[i, j].couleur := TCouleurDesCases.Aucune;
    end;
end;

procedure TGrilleDeJeu.FrameResize(Sender: TObject);
begin
  AfficherLaGrille;
end;

function TGrilleDeJeu.getAlphaColorFromCouleur(couleur: TCouleurDesCases)
  : talphacolor;
begin
  case couleur of
    TCouleurDesCases.rouge:
      result := talphacolors.red;
    TCouleurDesCases.vert:
      result := talphacolors.green;
    TCouleurDesCases.jaune:
      result := talphacolors.yellow;
    TCouleurDesCases.bleu:
      result := talphacolors.blue;
    TCouleurDesCases.blanc:
      result := talphacolors.white;
    TCouleurDesCases.noir:
      result := talphacolors.black;
    TCouleurDesCases.violet:
      result := talphacolors.violet;
  else
    raise exception.Create('Hu hu hu');
  end;
end;

function TGrilleDeJeu.hasPlusieursCouleurs: boolean;
var
  i, j: integer;
  couleur: TCouleurDesCases;
begin
  result := false;
  couleur := TCouleurDesCases.Aucune;
  for i := 0 to CNbCol - 1 do
  begin
    for j := 0 to CNbLig - 1 do
    begin
      if (couleur <> grille[i, j].couleur) then
        if (couleur = TCouleurDesCases.Aucune) then
          couleur := grille[i, j].couleur
        else
          result := true;
      if result then
        break;
    end;
    if result then
      break;
  end;
end;

procedure TGrilleDeJeu.InitialiserLaGrille;
var
  i, j: integer;
begin
  for i := 0 to CNbCol - 1 do
    for j := 0 to CNbLig - 1 do
    begin
      if assigned(grille[i, j].rect) then
      begin
        grille[i, j].rect.free;
        grille[i, j].rect := nil;
      end;
      grille[i, j].couleur := TCouleurDesCases.Aucune;
    end;
end;

procedure TGrilleDeJeu.RemplirLaGrille;
var
  i, j: integer;
  couleur: TCouleurDesCases;
begin
  for j := 0 to CNbLig - 1 do
    for i := 0 to CNbCol - 1 do
    begin
      if not assigned(grille[i, j].rect) then
      begin
        grille[i, j].rect := TRectangle.Create(self);
        grille[i, j].rect.Parent := GrilleAffichee;
        grille[i, j].rect.align := TAlignLayout.Client;
        grille[i, j].rect.margins.Left := 2;
        grille[i, j].rect.margins.right := 2;
        grille[i, j].rect.margins.top := 2;
        grille[i, j].rect.margins.bottom := 2;
        grille[i, j].rect.XRadius := 5;
        grille[i, j].rect.yRadius := 5;
        grille[i, j].rect.stroke.kind := TBrushKind.none;
        grille[i, j].rect.fill.kind := TBrushKind.solid;
        grille[i, j].rect.hittest := false;
      end;
      if CouleurAleatoire then
        case random(7) of
          0:
            couleur := TCouleurDesCases.rouge;
          1:
            couleur := TCouleurDesCases.vert;
          2:
            couleur := TCouleurDesCases.jaune;
          3:
            couleur := TCouleurDesCases.bleu;
          4:
            couleur := TCouleurDesCases.blanc;
          5:
            couleur := TCouleurDesCases.noir;
          6:
            couleur := TCouleurDesCases.violet;
        else
          raise exception.Create('Hu hu hu');
        end
      else
        couleur := InfosTournoi.grille[i, j];
      grille[i, j].couleur := couleur;
      grille[i, j].rect.fill.Color := getAlphaColorFromCouleur(couleur);
    end;
end;

procedure TGrilleDeJeu.RemplirLaGrilleDepuisGrilleTournoi;
begin
  RemplirLaGrille(false);
end;

initialization

randomize;

end.
