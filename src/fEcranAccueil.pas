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
/// File last update : 2025-03-30T17:54:04.000+02:00
/// Signature : 4a16f78f66e17045842a143e46e52aa145a64e1e
/// ***************************************************************************
/// </summary>

unit fEcranAccueil;

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
  FMX.Layouts,
  FMX.Objects,
  cBoutonMenu;

type
  TfrmEcranAccueil = class(T_AncetreCadreTraduit)
    ZoneBoutonsMenu: TVertScrollBox;
    btnJeuTraining: TBoutonMenu;
    btnHallOfFame: TBoutonMenu;
    btnReglages: TBoutonMenu;
    btnCreditsDuJeu: TBoutonMenu;
    btnQuitterLeProgramme: TBoutonMenu;
    btnJeuChrono: TBoutonMenu;
    btnJeuChallenge: TBoutonMenu;
    btnJeuTournoi: TBoutonMenu;
    procedure FrameResize(Sender: TObject);
    procedure btnQuitterLeProgrammeClick(Sender: TObject);
    procedure btnJeuTrainingClick(Sender: TObject);
    procedure btnJeuChronoClick(Sender: TObject);
    procedure btnJeuChallengeClick(Sender: TObject);
    procedure btnJeuTournoiClick(Sender: TObject);
    procedure btnHallOfFameClick(Sender: TObject);
    procedure btnReglagesClick(Sender: TObject);
    procedure btnCreditsDuJeuClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    constructor Create(AOwner: TComponent); override;
    { Déclarations publiques }

  end;

var
  frmEcranAccueil: TfrmEcranAccueil;

implementation

{$R *.fmx}

uses
  uInfosPartieEnCours,
  uEcrans;

procedure TfrmEcranAccueil.btnCreditsDuJeuClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmEcranAccueil.btnHallOfFameClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmEcranAccueil.btnJeuChallengeClick(Sender: TObject);
begin
  PartieEnCours.InitialiserPartie;
  PartieEnCours.ModeDeJeu := TModeDeJeu.challenge;
  // afficheecran(TEcranDuJeu.ChoixNiveauDifficulte);
  // TODO : à compléter
end;

procedure TfrmEcranAccueil.btnJeuChronoClick(Sender: TObject);
begin
  PartieEnCours.InitialiserPartie;
  PartieEnCours.ModeDeJeu := TModeDeJeu.Chrono;
  // afficheecran(TEcranDuJeu.ChoixNiveauDifficulte);
  // TODO : à compléter
end;

procedure TfrmEcranAccueil.btnJeuTournoiClick(Sender: TObject);
begin
  PartieEnCours.InitialiserPartie;
  PartieEnCours.ModeDeJeu := TModeDeJeu.Tournoi;
  afficheecran(TEcranDuJeu.ChoixTournoiWanOuLan);
end;

procedure TfrmEcranAccueil.btnJeuTrainingClick(Sender: TObject);
begin
  PartieEnCours.InitialiserPartie;
  PartieEnCours.ModeDeJeu := TModeDeJeu.Training;
  afficheecran(TEcranDuJeu.ChoixNiveauDifficulte);
end;

procedure TfrmEcranAccueil.btnQuitterLeProgrammeClick(Sender: TObject);
begin
  application.MainForm.Close;
end;

procedure TfrmEcranAccueil.btnReglagesClick(Sender: TObject);
begin
  // TODO : à compléter
end;

constructor TfrmEcranAccueil.Create(AOwner: TComponent);
begin
  inherited;
{$IF Defined(IOS) or Defined(ANDROID)}
  btnQuitterLeProgramme.Visible := false;
{$ENDIF}
  // TODO : à réactiver lorsque l'écran sera fait
  btnJeuChrono.Enabled := false;
  // TODO : à réactiver lorsque l'écran sera fait
  btnJeuChallenge.Enabled := false;
  // TODO : à réactiver lorsque l'écran sera fait
  btnReglages.Visible := false;
  // TODO : à réactiver lorsque l'écran sera fait
  btnCreditsDuJeu.Visible := false;
  // TODO : à réactiver lorsque l'écran sera fait
  btnHallOfFame.Enabled := false;
end;

procedure TfrmEcranAccueil.FrameResize(Sender: TObject);
var
  I: integer;
  Hauteur: single;
  HauteurElement: single;
  c: tcontrol;
begin
  inherited;
  Hauteur := 0;
  for I := 0 to ZoneBoutonsMenu.Content.ChildrenCount - 1 do
    if (ZoneBoutonsMenu.Content.children[I] is tcontrol) then
    begin
      c := ZoneBoutonsMenu.Content.children[I] as tcontrol;
      if c.Visible then
      begin
        HauteurElement := c.position.y + c.height + c.margins.Bottom;
        if Hauteur < HauteurElement then
          Hauteur := HauteurElement;
      end;
    end;
  if height - 10 < Hauteur then
    Hauteur := height - 10;
  ZoneBoutonsMenu.height := Hauteur;
end;

end.
