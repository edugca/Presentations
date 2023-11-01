function ds = dynamic_set_auxiliary_series(ds, params)
%
% Status : Computes Auxiliary variables of the dynamic model and returns a dseries
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

ds.AUX_ENDO_LEAD_71=ds.inflationq(1);
ds.AUX_ENDO_LEAD_75=ds.AUX_ENDO_LEAD_71(1);
ds.AUX_ENDO_LEAD_79=ds.AUX_ENDO_LEAD_75(1);
ds.AUX_ENDO_LEAD_106=ds.outputgap(1);
ds.AUX_ENDO_LEAD_110=ds.AUX_ENDO_LEAD_106(1);
ds.AUX_ENDO_LEAD_114=ds.AUX_ENDO_LEAD_110(1);
ds.AUX_ENDO_LAG_2_1=ds.pi(-1);
ds.AUX_ENDO_LAG_2_2=ds.AUX_ENDO_LAG_2_1(-1);
ds.AUX_ENDO_LAG_6_1=ds.outputgap(-1);
ds.AUX_ENDO_LAG_6_2=ds.AUX_ENDO_LAG_6_1(-1);
ds.AUX_ENDO_LAG_6_3=ds.AUX_ENDO_LAG_6_2(-1);
ds.AUX_ENDO_LAG_3_1=ds.interest(-1);
ds.AUX_ENDO_LAG_3_2=ds.AUX_ENDO_LAG_3_1(-1);
ds.AUX_ENDO_LAG_3_3=ds.AUX_ENDO_LAG_3_2(-1);
ds.AUX_ENDO_LAG_5_1=ds.inflationq(-1);
ds.AUX_ENDO_LAG_5_2=ds.AUX_ENDO_LAG_5_1(-1);
ds.AUX_ENDO_LAG_5_3=ds.AUX_ENDO_LAG_5_2(-1);
end
