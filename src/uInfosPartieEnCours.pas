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
/// File last update : 2025-03-30T17:54:52.000+02:00
/// Signature : fe4d7841dbf25557f243d96df3233b7f8e7c61f2
/// ***************************************************************************
/// </summary>

unit uInfosPartieEnCours;

interface

type
{$SCOPEDENUMS ON}
  TModeDeJeu = (Training, Chrono, Challenge, Tournoi);
  TTYpeDeTournoi = (Wan, Lan);
  TNiveauDifficulte = (Facile, Moyen, Difficile);
  TCouleurDesCases = (Aucune = 0, Rouge = 1, Vert = 2, Jaune = 3, Bleu = 4,
    Blanc = 5, Noir = 6, Violet = 7);

  TPartieEnCours = record
    Score: integer;
    NomDuJoueur: string;
    // TODO : nom du joueur à faire saisir en mode tournoi ou lors de l'enregistrement du score
    NiveauDeDifficulte: TNiveauDifficulte;
    ModeDeJeu: TModeDeJeu;
    TypeDeTournoi: TTYpeDeTournoi;
    PartieInitialisee: boolean;
    PartieDemarree: boolean;
    CouleurActuelle: TCouleurDesCases;
    procedure InitialiserPartie;
    procedure TerminerPartie;
  end;

var
  PartieEnCours: TPartieEnCours;

implementation

{ TPartieEnCours }

procedure TPartieEnCours.InitialiserPartie;
begin
  PartieInitialisee := true;
  PartieDemarree := false;
  Score := 0;
end;

procedure TPartieEnCours.TerminerPartie;
begin
  PartieInitialisee := false;
  PartieDemarree := false;
end;

initialization

PartieEnCours.NomDuJoueur := '';
// TODO : à récupérer dans les paramètres de l'application quand on les gèrera

PartieEnCours.NiveauDeDifficulte := TNiveauDifficulte.Facile;
// TODO : à récupérer dans les paramètres

PartieEnCours.ModeDeJeu := TModeDeJeu.Training;
// TODO : à récupérer dans les paramètres

PartieEnCours.TypeDeTournoi := TTYpeDeTournoi.Wan;
// TODO : à récupérer dans les paramètres

end.
