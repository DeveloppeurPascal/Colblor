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
/// File last update : 2025-03-30T17:53:48.000+02:00
/// Signature : 9d5f515431b91ac39e686f33f9ce6e5cc132505b
/// ***************************************************************************
/// </summary>

unit cBoutonMenu;

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
  FMX.Objects;

type
{$SCOPEDENUMS ON}
  TBoutonMenuType = (JeuEnTrainig, JeuEnChrono, JeuEnChallenge, JeuEnTournoi,
    CreditsDuJeu, HallOfFame, QuitterLeProgramme, Reglages, NiveauFacile,
    NiveauMoyen, NiveauDifficile, RetourAuMenu, Enregistrer, Charger,
    TournoiWan, TournoiLan);

  [ComponentPlatformsAttribute(pidAllPlatforms)]
  TBoutonMenu = class(T_AncetreCadreTraduit)
    background: TRectangle;
    text: TText;
    logo: TPath;
  private
    FBoutonMenuType: TBoutonMenuType;
    procedure SetBoutonMenuType(const Value: TBoutonMenuType);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property BoutonMenuType: TBoutonMenuType read FBoutonMenuType
      write SetBoutonMenuType;
  end;

var
  BoutonMenu: TBoutonMenu;

procedure Register;

implementation

{$R *.fmx}

uses
  uDMTraductions;

constructor TBoutonMenu.Create(AOwner: TComponent);
begin
  inherited;
  background.Stored := false;
  text.Stored := false;
  logo.Stored := false;
  Height := 48;
  logo.Width := logo.Height;
end;

procedure TBoutonMenu.SetBoutonMenuType(const Value: TBoutonMenuType);
begin
  // TODO : traduire les textes
  FBoutonMenuType := Value;
  text.AutoSize := false;
  text.Width := Width;
  case FBoutonMenuType of
    TBoutonMenuType.JeuEnTrainig:
      begin
        text.text := _('btnJeuEnTrainig', 'Training');
        logo.data.data :=
          'M12 3L1 9L5 11.18V17.18L12 21L19 17.18V11.18L21 10.09V17H23V9L12 3M18'
          + '.82 9L12 12.72L5.18 9L12 5.28L18.82 9M17 16L12 18.72L7 16V12.27L12 1'
          + '5L17 12.27V16Z';
      end;
    TBoutonMenuType.JeuEnChrono:
      begin
        text.text := _('btnJeuEnChrono', 'Chrono');
        logo.data.data :=
          'M13,2.05V4.05C17.39,4.59 20.5,8.58 19.96,12.97C19.5,16.61 16.64,19.5 '
          + '13,19.93V21.93C18.5,21.38 22.5,16.5 21.95,11C21.5,6.25 17.73,2.5 13,'
          + '2.03V2.05M5.67,19.74C7.18,21 9.04,21.79 11,22V20C9.58,19.82 8.23,19.2'
          + '5 7.1,18.37L5.67,19.74M7.1,5.74C8.22,4.84 9.57,4.26 11,4.06V2.06C9.05,'
          + '2.25 7.19,3 5.67,4.26L7.1,5.74M5.69,7.1L4.26,5.67C3,7.19 2.25,9.04 2.05'
          + ',11H4.05C4.24,9.58 4.8,8.23 5.69,7.1M4.06,13H2.06C2.26,14.96 3.03,16.81 '
          + '4.27,18.33L5.69,16.9C4.81,15.77 4.24,14.42 4.06,13M10,16.5L16,12L10,7.5V1'
          + '6.5Z';
      end;
    TBoutonMenuType.JeuEnChallenge:
      begin
        text.text := _('btnJeuEnChallenge', 'Challenge');
        logo.data.data :=
          'M12,20C7.59,20 4,16.41 4,12C4,7.59 7.59,4 12,4C16.41,4 20,7.59 20,12C'
          + '20,16.41 16.41,20 12,20M12,2A10,10 0 0,0 2,12A10,10 0 0,0 12,22A10,1'
          + '0 0 0,0 22,12A10,10 0 0,0 12,2M10,16.5L16,12L10,7.5V16.5Z';
      end;
    TBoutonMenuType.JeuEnTournoi:
      begin
        text.text := _('btnJeuEnTournoi', 'Tournoi');
        logo.data.data :=
          'M15,20A1,1 0 0,0 14,19H13V17H17A2,2 0 0,0 19,15V5A2,2 0 0,0 17,3H7A2,'
          + '2 0 0,0 5,5V15A2,2 0 0,0 7,17H11V19H10A1,1 0 0,0 9,20H2V22H9A1,1 0 0'
          + ',0 10,23H14A1,1 0 0,0 15,22H22V20H15M7,15V5H17V15H7M10,14V6L15,10L10,'
          + '14Z';
      end;
    TBoutonMenuType.CreditsDuJeu:
      begin
        text.text := _('btnCreditsDuJeu', 'Crédits');
        logo.data.data :=
          'M11,9H13V7H11M12,20C7.59,20 4,16.41 4,12C4,7.59 7.59,4 12,4C16.41,4 2'
          + '0,7.59 20,12C20,16.41 16.41,20 12,20M12,2A10,10 0 0,0 2,12A10,10 0 0'
          + ',0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M11,17H13V11H11V17Z';
      end;
    TBoutonMenuType.HallOfFame:
      begin
        text.text := _('btnHallOfFame', 'Tableau des scores');
        logo.data.data :=
          'M12,7.09L14.45,8.58L13.8,5.77L16,3.89L13.11,3.64L12,1L10.87,3.64L8,3.'
          + '89L10.18,5.77L9.5,8.58L12,7.09M4,13.09L6.45,14.58L5.8,11.77L8,9.89L5'
          + '.11,9.64L4,7L2.87,9.64L0,9.89L2.18,11.77L1.5,14.58L4,13.09M20,10.09L2'
          + '2.45,11.58L21.8,8.77L24,6.89L21.11,6.64L20,4L18.87,6.64L16,6.89L18.18,'
          + '8.77L17.5,11.58L20,10.09M15,23H9V10H15V23M7,23H1V17H7V23M23,23H17V13H23'
          + 'V23Z';
      end;
    TBoutonMenuType.QuitterLeProgramme:
      begin
        text.text := _('btnQuitterLeProgramme', 'Quitter');
        logo.data.data :=
          'M13.34,8.17C12.41,8.17 11.65,7.4 11.65,6.47A1.69,1.69 0 0,1 13.34,4.7'
          + '8C14.28,4.78 15.04,5.54 15.04,6.47C15.04,7.4 14.28,8.17 13.34,8.17M1'
          + '0.3,19.93L4.37,18.75L4.71,17.05L8.86,17.9L10.21,11.04L8.69,11.64V14.5'
          + 'H7V10.54L11.4,8.67L12.07,8.59C12.67,8.59 13.17,8.93 13.5,9.44L14.36,10'
          + '.79C15.04,12 16.39,12.82 18,12.82V14.5C16.14,14.5 14.44,13.67 13.34,12.'
          + '4L12.84,14.94L14.61,16.63V23H12.92V17.9L11.14,16.21L10.3,19.93M21,23H19V'
          + '3H6V16.11L4,15.69V1H21V23M6,23H4V19.78L6,20.2V23Z';
      end;
    TBoutonMenuType.Reglages:
      begin
        text.text := _('btnReglages', 'Réglages');
        logo.data.data :=
          'M12,8A4,4 0 0,1 16,12A4,4 0 0,1 12,16A4,4 0 0,1 8,12A4,4 0 0,1 12,8M1'
          + '2,10A2,2 0 0,0 10,12A2,2 0 0,0 12,14A2,2 0 0,0 14,12A2,2 0 0,0 12,10'
          + 'M10,22C9.75,22 9.54,21.82 9.5,21.58L9.13,18.93C8.5,18.68 7.96,18.34 7'
          + '.44,17.94L4.95,18.95C4.73,19.03 4.46,18.95 4.34,18.73L2.34,15.27C2.21,'
          + '15.05 2.27,14.78 2.46,14.63L4.57,12.97L4.5,12L4.57,11L2.46,9.37C2.27,9.'
          + '22 2.21,8.95 2.34,8.73L4.34,5.27C4.46,5.05 4.73,4.96 4.95,5.05L7.44,6.05'
          + 'C7.96,5.66 8.5,5.32 9.13,5.07L9.5,2.42C9.54,2.18 9.75,2 10,2H14C14.25,2 1'
          + '4.46,2.18 14.5,2.42L14.87,5.07C15.5,5.32 16.04,5.66 16.56,6.05L19.05,5.05C'
          + '19.27,4.96 19.54,5.05 19.66,5.27L21.66,8.73C21.79,8.95 21.73,9.22 21.54,9.3'
          + '7L19.43,11L19.5,12L19.43,13L21.54,14.63C21.73,14.78 21.79,15.05 21.66,15.27L'
          + '19.66,18.73C19.54,18.95 19.27,19.04 19.05,18.95L16.56,17.95C16.04,18.34 15.5,'
          + '18.68 14.87,18.93L14.5,21.58C14.46,21.82 14.25,22 14,22H10M11.25,4L10.88,6.61C'
          + '9.68,6.86 8.62,7.5 7.85,8.39L5.44,7.35L4.69,8.65L6.8,10.2C6.4,11.37 6.4,12.64 6'
          + '.8,13.8L4.68,15.36L5.43,16.66L7.86,15.62C8.63,16.5 9.68,17.14 10.87,17.38L11.24,'
          + '20H12.76L13.13,17.39C14.32,17.14 15.37,16.5 16.14,15.62L18.57,16.66L19.32,15.36L1'
          + '7.2,13.81C17.6,12.64 17.6,11.37 17.2,10.2L19.31,8.65L18.56,7.35L16.15,8.39C15.38,7'
          + '.5 14.32,6.86 13.12,6.62L12.75,4H11.25Z';
      end;
    TBoutonMenuType.NiveauFacile:
      begin // TODO : découper chaines TPath qui dépassent (pour esthétique du code source)
        text.text := _('btnNiveauFacile', 'Niveau facile');
        logo.data.data :=
          'M16 20H8V6H16M16.67 4H15V2H9V4H7.33C6.6 4 6 4.6 6 5.33V20.67C6 21.4 6.6 22 7.33 22H16.67C17.41 22 18 21.41 18 20.67V5.33C18 4.6 17.4 4 16.67 4M15 16H9V19H15V16';
      end;
    TBoutonMenuType.NiveauMoyen:
      begin
        text.text := _('btnNiveauMoyen', 'Niveau moyen');
        logo.data.data :=
          'M16 20H8V6H16M16.67 4H15V2H9V4H7.33C6.6 4 6 4.6 6 5.33V20.67C6 21.4 6.6 22 7.33 22H16.67C17.41 22 18 21.41 18 20.67V5.33C18 4.6 17.4 4 16.67 4M15 16H9V19H15V16M15 11.5H9V14.5H15V11.5Z';
      end;
    TBoutonMenuType.NiveauDifficile:
      begin
        text.text := _('btnNiveauDifficile', 'Niveau difficile');
        logo.data.data :=
          'M16 20H8V6H16M16.67 4H15V2H9V4H7.33C6.6 4 6 4.6 6 5.33V20.67C6 21.4 6.6 22 7.33 22H16.67C17.41 22 18 21.41 18 20.67V5.33C18 4.6 17.4 4 16.67 4M15 16H9V19H15V16M15 7H9V10H15V7M15 11.5H9V14.5H15V11.5Z';
      end;
    TBoutonMenuType.RetourAuMenu:
      begin
        text.text := _('btnRetourAuMenu', 'Menu');
        logo.data.data :=
          'M12 5.69L17 10.19V18H15V12H9V18H7V10.19L12 5.69M12 3L2 12H5V20H11V14H13V20H19V12H22L12 3Z';
      end;
    TBoutonMenuType.Enregistrer:
      begin
        text.text := _('btnEnregistrer', 'Enregistrer');
        logo.data.data :=
          'M5,3A2,2 0 0,0 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5.5L18.5,3H17V9A1,1 0 0,1 16,10H8A1,1 0 0,1 7,9V3H5M12,4V9H15V4H12M7,12H17A1,1 0 0,1 18,13V19H6V13A1,1 0 0,1 7,12Z';
      end;
    TBoutonMenuType.Charger:
      begin
        text.text := _('btnCharger', 'Charger');
        logo.data.data :=
          'M20,18H4V8H20M20,6H12L10,4H4C2.89,4 2,4.89 2,6V18A2,2 0 0,0 4,20H20A2,2 0 0,0 22,18V8C22,6.89 21.1,6 20,6Z';
      end;
    TBoutonMenuType.TournoiWan: // via Internet
      begin
        text.text := _('btnTournoiWan', 'Wan');
        logo.data.data :=
          'M12,2A8,8 0 0,0 4,10C4,14.03 7,17.42 11,17.93V19H10A1,1 0 0,0 9,20H2V'
          + '22H9A1,1 0 0,0 10,23H14A1,1 0 0,0 15,22H22V20H15A1,1 0 0,0 14,19H13V'
          + '17.93C17,17.43 20,14.03 20,10A8,8 0 0,0 12,2M12,4C12,4 12.74,5.28 13.'
          + '26,7H10.74C11.26,5.28 12,4 12,4M9.77,4.43C9.5,4.93 9.09,5.84 8.74,7H6.'
          + '81C7.5,5.84 8.5,4.93 9.77,4.43M14.23,4.44C15.5,4.94 16.5,5.84 17.19,7H1'
          + '5.26C14.91,5.84 14.5,4.93 14.23,4.44M6.09,9H8.32C8.28,9.33 8.25,9.66 8.2'
          + '5,10C8.25,10.34 8.28,10.67 8.32,11H6.09C6.03,10.67 6,10.34 6,10C6,9.66 6.'
          + '03,9.33 6.09,9M10.32,9H13.68C13.72,9.33 13.75,9.66 13.75,10C13.75,10.34 13'
          + '.72,10.67 13.68,11H10.32C10.28,10.67 10.25,10.34 10.25,10C10.25,9.66 10.28,'
          + '9.33 10.32,9M15.68,9H17.91C17.97,9.33 18,9.66 18,10C18,10.34 17.97,10.67 17.'
          + '91,11H15.68C15.72,10.67 15.75,10.34 15.75,10C15.75,9.66 15.72,9.33 15.68,9M6.'
          + '81,13H8.74C9.09,14.16 9.5,15.07 9.77,15.56C8.5,15.06 7.5,14.16 6.81,13M10.74,1'
          + '3H13.26C12.74,14.72 12,16 12,16C12,16 11.26,14.72 10.74,13M15.26,13H17.19C16.5,'
          + '14.16 15.5,15.07 14.23,15.57C14.5,15.07 14.91,14.16 15.26,13Z';
      end;
    TBoutonMenuType.TournoiLan: // sur réseau local
      begin
        text.text := _('btnTournoiLan', 'Lan');
        logo.data.data :=
          'M10,2C8.89,2 8,2.89 8,4V7C8,8.11 8.89,9 10,9H11V11H2V13H6V15H5C3.89,1'
          + '5 3,15.89 3,17V20C3,21.11 3.89,22 5,22H9C10.11,22 11,21.11 11,20V17C'
          + '11,15.89 10.11,15 9,15H8V13H16V15H15C13.89,15 13,15.89 13,17V20C13,21'
          + '.11 13.89,22 15,22H19C20.11,22 21,21.11 21,20V17C21,15.89 20.11,15 19,'
          + '15H18V13H22V11H13V9H14C15.11,9 16,8.11 16,7V4C16,2.89 15.11,2 14,2H10M1'
          + '0,4H14V7H10V4M5,17H9V20H5V17M15,17H19V20H15V17Z';
      end;
  else
    text.text := 'n/a';
    logo.data.data := '';
  end;
  text.AutoSize := true;
end;

procedure Register;
begin
  RegisterComponents('Colblor', [TBoutonMenu]);
end;

end.
