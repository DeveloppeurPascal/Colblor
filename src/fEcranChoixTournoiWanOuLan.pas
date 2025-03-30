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
/// File last update : 2025-03-30T17:54:16.000+02:00
/// Signature : 356a94a46ff77ca79d5c316ce6e72e4f28616d79
/// ***************************************************************************
/// </summary>

unit fEcranChoixTournoiWanOuLan;

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
  cBoutonMenu;

type
  TfrmEcranChoixTournoiWanOuLan = class(T_AncetreCadreTraduit)
    ZoneBoutonsMenu: TVertScrollBox;
    btnTournoiWan: TBoutonMenu;
    btnTournoiLan: TBoutonMenu;
    procedure FrameResize(Sender: TObject);
    procedure btnTournoiWanClick(Sender: TObject);
    procedure btnTournoiLanClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmEcranChoixTournoiWanOuLan: TfrmEcranChoixTournoiWanOuLan;

implementation

{$R *.fmx}

uses
  uInfosPartieEnCours,
  uEcrans,
  uTournoiAPI;

procedure TfrmEcranChoixTournoiWanOuLan.btnTournoiLanClick(Sender: TObject);
begin
  PartieEnCours.TypeDeTournoi := TTYpeDeTournoi.lan;
  // TODO : afficher écran de choix des infos du serveur à utiliser (protocole / IP / port / dossier)
  // AfficheEcran(TEcranDuJeu.Jeu);
end;

procedure TfrmEcranChoixTournoiWanOuLan.btnTournoiWanClick(Sender: TObject);
begin
  PartieEnCours.TypeDeTournoi := TTYpeDeTournoi.Wan;
{$IFDEF DEBUG}
{$IFDEF MSWINDOWS}
  // WampServer en local
  // TournoiAPIServeurURL('http://colblorserver/');
  TournoiAPIServeurURL('https://colblor.gamolf.fr/ColblorServer/');
  // TODO : réactiver serveur de test
{$ELSE}
  // WampServer en réseau local sur VM Twitch
  // TournoiAPIServeurURL('http://192.168.1.169/');
  TournoiAPIServeurURL('https://colblor.gamolf.fr/ColblorServer/');
  // TODO : réactiver serveur de test
{$ENDIF}
{$ELSE}
  // en production sur le serveur web
  TournoiAPIServeurURL('https://colblor.gamolf.fr/ColblorServer/');
{$ENDIF}
  AfficheEcran(TEcranDuJeu.Jeu);
end;

constructor TfrmEcranChoixTournoiWanOuLan.Create(AOwner: TComponent);
begin
  inherited;
  btnTournoiLan.Enabled := false; // TODO : coder le tournoi en réseau local
end;

procedure TfrmEcranChoixTournoiWanOuLan.FrameResize(Sender: TObject);
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
