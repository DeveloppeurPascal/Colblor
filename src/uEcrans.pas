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
/// File last update : 2025-03-30T17:54:36.000+02:00
/// Signature : d5dfe78d18fc81ebfb9a791d391324a1b14c312c
/// ***************************************************************************
/// </summary>

unit uEcrans;

interface

type
{$SCOPEDENUMS ON}
  TEcranDuJeu = (Aucun, Accueil, CreditsDuJeu, HallOfFame, Reglages,
    ChoixNiveauDifficulte, Jeu, JeuTraining, JeuChrono, JeuChallenge,
    JeuTournoi, ChoixTournoiWanOuLan);

const
  CIJeuGUID = '{A6FEB9B5-44E4-4B77-A11A-3EDEA83809D4}';

type
  IJeu = interface
    [CIJeuGUID]
    procedure InitialiserLeJeu;
  end;

procedure AfficheEcran(EcranAAfficher: TEcranDuJeu);

implementation

uses
  fmx.types,
  fmx.forms,
  System.Generics.Collections,
  System.SysUtils,
  fAncetreCadreTraduit,
  fEcranAccueil,
  fEcranChoixNiveauDifficulte,
  fEcranJeu,
  fColblor,
  uInfosPartieEnCours,
  fEcranChoixTournoiWanOuLan;

type
  TEcransList = TDictionary<TEcranDuJeu, T_AncetreCadreTraduit>;

var
  EcransList: TEcransList;

function getEcran(Ecran: TEcranDuJeu): T_AncetreCadreTraduit;
begin
  result := nil;
  if not assigned(EcransList) then
    EcransList := TEcransList.Create;
  if not EcransList.TryGetValue(Ecran, result) then
  begin
    case Ecran of
      TEcranDuJeu.Aucun:
        result := nil;
      TEcranDuJeu.Accueil:
        result := tfrmEcranAccueil.Create(frmColblor);
      TEcranDuJeu.ChoixNiveauDifficulte:
        result := TfrmEcranChoixNiveauDifficulte.Create(frmColblor);
      TEcranDuJeu.ChoixTournoiWanOuLan:
        result := TfrmEcranChoixTournoiWanOuLan.Create(frmColblor);
      TEcranDuJeu.Jeu:
        begin
          case PartieEnCours.ModeDeJeu of
            TModeDeJeu.Training:
              result := getEcran(TEcranDuJeu.JeuTraining);
            TModeDeJeu.Chrono:
              result := getEcran(TEcranDuJeu.JeuChrono);
            TModeDeJeu.Challenge:
              result := getEcran(TEcranDuJeu.JeuChallenge);
            TModeDeJeu.Tournoi:
              result := getEcran(TEcranDuJeu.JeuTournoi);
          else
            raise exception.Create('Mode de jeu non géré.'); // TODO : traduire
          end;
          exit;
        end;
      TEcranDuJeu.JeuTraining, TEcranDuJeu.JeuTournoi:
        result := TfrmEcranJeu.Create(frmColblor);
      // TODO : gérer modes chrono et challenge
    else
      raise exception.Create('Type d''écran non géré.'); // TODO : traduire
    end;
    if assigned(result) then
    begin
      result.name := '';
      EcransList.Add(Ecran, result);
    end;
  end;
end;

var
  EcranActuel: TEcranDuJeu;

procedure AfficheEcran(EcranAAfficher: TEcranDuJeu);
var
  Ecran: T_AncetreCadreTraduit;
begin
  if (EcranAAfficher <> EcranActuel) then
  begin
    // Ancien écran
    Ecran := getEcran(EcranActuel);
    if assigned(Ecran) then
    begin
      frmColblor.animMasquageEcran.Parent := Ecran;
      frmColblor.animMasquageEcran.StartValue := 0;
      frmColblor.animMasquageEcran.stopValue := -frmColblor.clientheight;
      Ecran.Align := talignlayout.none;
      frmColblor.animMasquageEcran.Start;
    end;
    // Nouvel écran
    Ecran := getEcran(EcranAAfficher);
    if assigned(Ecran) then
    begin
      EcranActuel := EcranAAfficher;
      frmColblor.animAffichageEcran.Parent := Ecran;
      frmColblor.animAffichageEcran.StartValue := frmColblor.clientheight;
      frmColblor.animAffichageEcran.stopValue := 0;
      Ecran.Align := talignlayout.none;
      Ecran.position.x := 0;
      Ecran.width := frmColblor.clientwidth;
      Ecran.height := frmColblor.clientheight;
      // TODO : voir pourquoi la zone centrée dans EcranAccueil ne se repositionne pas d'elle-même
      Ecran.Parent := frmColblor;
      frmColblor.animAffichageEcran.Start;
      if (EcranAAfficher = TEcranDuJeu.Jeu) then
      begin
        if not PartieEnCours.PartieInitialisee then
          PartieEnCours.InitialiserPartie;
        if not PartieEnCours.PartieDemarree then
          if Supports(Ecran, tguid.Create(CIJeuGUID)) then
            (Ecran as IJeu).InitialiserLeJeu;
      end;
    end;
  end;
end;

initialization

EcranActuel := TEcranDuJeu.Aucun;
EcransList := nil;

finalization

if assigned(EcransList) then
  freeandnil(EcransList);

end.
