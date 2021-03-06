% Script to show the impact of using basis functions
% on efficiency and power.
% Corresponds to Figure 3 in Liu and Frank 2004
%
% Files are created by batch_basis.m
% 
%
%  files used are:
%    ne2l0123no80z0ds2c1v3cn0ba0 -- corresponds to no basis used
%    ne2l0123no80z0ds2c1v3cn0ba1 -- corresponds to basis function is used
%    
%  



cmspan = [2:100 110:20:200];
blockspan =[2:100 110:20:200];


figure(1);clf;

subplot('position',[0.05 0.08 0.6 0.85]);


dscale = 1.0;
escale = 1.0;




nevents = 2;
Q = nevents;


% LOAD THE NO BASIS DATA FILE
load  ne2l0123no80z0ds2c1v3cn0ba0;
mstimmat0 = mstimmat;
% UPPER BOUNDS
atrace = approxtrace(nummods,numones,npts);
atrace = atrace/((1-numones/npts)*numones*nummods);
tmaxeff = npts/(2*(Q+1)*nummods);

tmaxdet = npts*nummods/(2*(Q+1));
neffmat = escale*effmat/tmaxeff;
ndetmat = dscale*detmat/tmaxdet;
nreffmat = escale*reffmat/tmaxeff;
nrdetmat = dscale*rdetmat/tmaxdet;
nmeffmat = escale*meffmat/tmaxeff;
nmdetmat = dscale*mdetmat/tmaxdet;

% THEORETICAL CURVES
k = nummods;
i0 = 1.0;
alpha =[1/k 0.1:0.05:1.0];
%thetavec = [45  55 65  80 90]/180*pi;
thetavec = [45   90]/180*pi;
teff = alpha.*(1-alpha) ./(1+alpha*(k^2-2*k))*i0*nummods*npts/(2*(Q+1));
alphamat = alpha(:)*ones(1,length(thetavec));
teffmat = teff(:)*ones(1,length(thetavec));
xrangemat = ones(length(alpha),1)*thetavec(:)';

tdet =i0*nummods*((1-alphamat).*(sin(xrangemat).^2)/(k-1)+alphamat.* ...
	  cos(xrangemat).^2);
tdet = tdet*npts/(2*(Q+1));
ntdet = tdet/tmaxdet;
nteffmat = teffmat/tmaxeff;
iorder = 1;
    
ind= 1;dind = 1;itype = 1;    
% PICK BEST 10 RANDOM DESIGNS
[s,s_ind] = sort(squeeze(nreffmat(itype,iorder,dind,:,1)));
s_ind = flipud(s_ind(:));
rind = s_ind(1);
	
% LOAD THE BASIS DATA FILE	
load  ne2l0123no80z0ds2c1v3cn0ba1;	

neffmat_b = escale*effmat/tmaxeff;
ndetmat_b = dscale*detmat/tmaxdet;
nreffmat_b = escale*reffmat/tmaxeff;
nrdetmat_b = dscale*rdetmat/tmaxdet;
nmeffmat_b = escale*meffmat/tmaxeff;
nmdetmat_b = dscale*mdetmat/tmaxdet;


% PLOT THE DATA


	hp = plot(squeeze(ndetmat(itype,iorder,dind,blockspan,1)),squeeze(neffmat(itype,iorder,dind,blockspan,1)),'m+',...
	     squeeze(ndetmat(itype,iorder,dind,blockspan,6)),squeeze(neffmat(itype, ...
						  iorder,dind,blockspan,6)),'g+',...
		  squeeze(nmdetmat(itype,iorder,dind,1,1)),squeeze(nmeffmat(itype, ...
						  iorder,dind,1,1)),'ro',...
		  squeeze(nmdetmat(itype,iorder,dind,cmspan,1)),squeeze(nmeffmat(itype, ...
						  iorder,dind,cmspan,1)),'r+', ...
             squeeze(ndetmat_b(itype,iorder,dind,blockspan,1)),squeeze(neffmat_b(itype,iorder,dind,blockspan,1)),'c+',...
	     squeeze(ndetmat_b(itype,iorder,dind,blockspan,6)),squeeze(neffmat_b(itype, ...
						  iorder,dind,blockspan,6)),'y+',...
		  squeeze(nmdetmat_b(itype,iorder,dind,1,1)),squeeze(nmeffmat_b(itype, ...
						  iorder,dind,1,1)),'bo',...
		  squeeze(nmdetmat_b(itype,iorder,dind,cmspan,1)),squeeze(nmeffmat_b(itype, ...
						  iorder,dind,cmspan,1)),'b+');

	set(hp(3),'MarkerFaceColor','r','MarkerSize',8);
	set(hp(7),'MarkerFaceColor','b','MarkerSize',8);
	set(hp(6),'Color',[0.5 0.5 0.5]);
	fs = get(gca,'Fontsize');
	set(gca,'FontSize',6);
	hl = legend('1-block','30-block','m-sequence','clustered m-seq',...
	       '1-block w/ basis','30-block w/ basis','m-sequence w/ basis',...
                     'clustered m-seq w/ basis',1);
	set(hl,'FontSize',10);
	set(gca,'FontSize',fs);



	hold on;

	axis([0 0.5 0 7]);
	  plot(ntdet,15/4*nteffmat,'k-');
	  plot(ntdet,nteffmat,'k-');


	

	set(gca,'FontSize',12);
	grid;
	ylabel('Normalized \xi_{tot}')
	xlabel('Normalized R_{tot}')
	title(['(a) Efficiency and Power for Q = 2, with and without basis',...
	       ' functions']);




subplot('position',[0.7 0.08 0.25 0.85]);
if ~exist('e2_0');
e2_0 = calcentvec(squeeze(mstimmat0(1,:,1,:)),2);
end
if ~exist('e2');

e2 = calcentvec(squeeze(mstimmat(1,:,1,:)),2);
end

he = plot(2.^e2(cmspan),squeeze(nmeffmat_b(itype,iorder,dind,cmspan,1)),'b+',...
     2.^e2(1),squeeze(nmeffmat_b(itype,iorder,dind,1,1)),'bo',...
     2.^e2_0(1),squeeze(nmeffmat(itype,iorder,dind,1,1)),'ro',...
	  2.^e2_0(cmspan),squeeze(nmeffmat(itype,iorder,dind,cmspan,1)),'r+');
set(he(2),'MarkerFaceColor','b','MarkerSize',8);
set(he(3),'MarkerFaceColor','r','MarkerSize',8);
grid;
axis([1 3.2 0 7]);
set(gca,'FontSize',12);
ylabel('Normalized \xi_{tot}');
xlabel('2\^H_2');
title('Efficiency w/ basis vs. 2\^(Entropy)');
if ~exist('doprint');doprint = 0;end
if doprint
print -dtiff NIMG770_fig3.tif
exportfig(gcf,'NIMG770_fig3.eps','color','cmyk','FontMode','Scaled', ...
	  'Fontsize',1);
end


