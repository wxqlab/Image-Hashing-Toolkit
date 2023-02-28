%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this file is used to transform the real value into binary code {-1,1}
%
%              min ||B-FQ||_F^2  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [binary_coding, Q] = binaryValueCoding(F, config)
	step  = config.step;
	k = size(F, 2);
	Q = orth(rand(k,k));
	ori_B = zeros(size(F));

    for i = 1:step

		%disp('step one...');
		B = calFromQ(Q, F);
		
		%disp('step two...');
		Q = calFromB(B, F);
	end
	binary_coding = B;
end

function B = calFromQ(Q, F)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       fix Q, cal B                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      max ||B-V||_F^2                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	V = F * Q;
	code_number = size(V, 2);
	items = size(V, 1);
	half_num = floor(items/2);

	B = [];
	for i = 1:code_number
		current_vector = V(:,i);
		cal_vector = zeros(items,1);
		
		[coding_sorted, coding_posi] = sort(current_vector, 'descend');
		cal_vector(coding_posi(1:half_num)) = 1;
             cal_vector(coding_posi(half_num+1:end)) = -1;
		B = [B,cal_vector];
	end
	
end


function Q = calFromB(B, F)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       fix B, cal Q                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	M = B'*F;
	[U,S,V] = svd(M);
	Q = V*U';
end
