unit uIcms10_30;

interface

uses uBaseIcmsProprio, uValorIcms, uBaseIcmsST, uValorIcmsST,  uIIcms10_30;

type
  TIcms10_30 = class(TInterfacedObject, IIcms10_30)
  private
    FBaseIcmsProprio: TBaseIcmsProprio;
    FIcmsProprio: TValorIcms;
    FBaseIcmsST: TBaseIcmsST;
    FIcmsST: TValorIcmsST;
    function ValorBaseIcmsProprio: currency;
    function ValorIcmsProprio: currency;
    function ValorBaseIcmsST: currency;
    function ValorIcmsST: currency;
    function ValorIcmsSTDesonerado: currency;
  public
    constructor Create(_valorProduto,
                       _valorFrete,
                       _valorSeguro,
                       _despesasAcessorias,
                       _valorDesconto,
                       _aliquotaIcms,
                       _aliquotaIcmsST,
                       _mva: currency;
                       _percentualReducaoST: currency = 0;
                       _valorIpi: currency = 0);
     destructor Destroy; override;

  end;

implementation
uses acbrutil.Math;
{ TIcms10 }

constructor TIcms10_30.Create(_valorProduto,
                           _valorFrete,
                           _valorSeguro,
                           _despesasAcessorias,
                           _valorDesconto,
                           _aliquotaIcms,
                           _aliquotaIcmsST,
                           _mva,
                           _percentualReducaoST,
                           _valorIpi: currency);
begin
 FBaseIcmsProprio := TBaseIcmsProprio.Create(_valorProduto,
                           _valorFrete,
                           _valorSeguro,
                           _despesasAcessorias,
                           _valorDesconto);

 FIcmsProprio := TValorIcms.Create(FBaseIcmsProprio, _aliquotaIcms);

 FBaseIcmsST := TBaseIcmsST.Create(FBaseIcmsProprio, _mva, _percentualReducaoST);

 FIcmsST := TValorIcmsST.Create(FBaseIcmsST, _aliquotaIcmsST, FIcmsProprio);

end;

destructor TIcms10_30.Destroy;
begin
  FBaseIcmsProprio.Free;
  FIcmsProprio.Free;
  FBaseIcmsST.Free;
  FIcmsST.Free;
  inherited;
end;

function TIcms10_30.ValorBaseIcmsProprio: currency;
begin
  result := FBaseIcmsProprio.CalcularBaseIcmsProprio;
end;

function TIcms10_30.ValorIcmsProprio: currency;
begin

 result := RoundABNT(FIcmsProprio.GetValorIcms, 2);

end;

function TIcms10_30.ValorBaseIcmsST: currency;
begin
  result := FBaseIcmsST.CalcularBaseIcmsST;
end;


function TIcms10_30.ValorIcmsST: currency;
begin

 result := RoundABNT(FIcmsST.CalcularValorIcmsST,2);

end;

function TIcms10_30.ValorIcmsSTDesonerado: currency;
var
 valorICMSSTNormal: currency;
begin
  valorICMSSTNormal :=  FIcmsST.CalcularValorNormalIcmsST;

  result := RoundABNT(valorICMSSTNormal - FIcmsST.CalcularValorIcmsST,2);
end;

end.