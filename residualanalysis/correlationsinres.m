if ~exist('namecore','var')
    namecore = 'D10ptBMrandPSFgauss_StretchCoef2_N10_offset100_nc';
end
chall=2*ones(length(iteration),length(ncvec),(ncvec(end)-1)^2);
for ii=1:length(ncvec)
    for jj=1:length(iteration)
%         r=load (['D10ptBMrandPSFgauss_StretchCoef2_N10_offset100_nc' num2str(ncvec(ii)) '/results_iter' num2str(iteration(jj)) '.mat']);
        r=load ([namecore num2str(ncvec(ii)) '/results_iter' num2str(iteration(jj)) '.mat']);
        if isfield(r.res,'a')
            r.res.h=r.res.a;
        end
        %     r=load (['results_updates_nmfclassic_nc' num2str(ncvec(ii)) '/results_iter' num2str(iteration) '.mat']);
        if isfield(r.peval,'data_dir')
            d = load(['~/' r.peval.data_path '/' r.peval.data_dir '/' r.peval.data_file]);
        else 
            if exist('dpixc', 'var')
                d.dpixc = dpixc; 
            else
                d = load ('dpixc');
            end                             
        end
        resid = (r.res.w*r.res.h - reshape(d.dpixc, r.peval.nx*r.peval.ny, r.peval.nt));
        % pixels correlations:
        cp = (corrcoef(resid'));
        cpmax(jj,ii) = max(cp(cp<1));
        cpmin(jj,ii) = min(cp(cp<1));
        cpmean(jj,ii) = mean(cp(cp<1));
        cpmeanpos(jj,ii) = mean(cp(and(cp>0,cp<1)));
        cpmeanneg(jj,ii) = mean(cp(cp<0));        
        % intensity correlations:
        if size(r.res.h,1)>2
            ch = corr(r.res.h(1:end-1,:)');
            chall(jj,ii,1:numel(ch))=ch(:);
            chmax(jj,ii) = max(ch(ch<1));
            %     chmin(ii) = min(min(corr(r.res.h(1:end-1,:)')-eye(size(r.res.h,1)-1)));
            chmin(jj,ii) = min(ch(:));
            
            chmean(jj,ii)=mean(ch(ch<1));
            chmeanpos(jj,ii)=mean(ch(and(ch<1,ch>0)));
            chmeanneg(jj,ii)=mean(ch(ch<0));
        end
%         h=hinton(ch);
        ll(jj,ii)=loglikelihoodPoisson(reshape(d.dpixc,r.peval.nx*r.peval.ny,r.peval.nt),r.res.w*r.res.h);
        if isfield(r.res, 'lb')
            lb(jj,ii) = r.res.lb;
        end

    end
end

% figure
% plot(ncvec, chmax.*(abs(chmin)),'s-r')
