% Generate a measurement vector for MHP
function k = generate_measurement(data,tstep)
  col = 1;
  k = zeros(1,data.order_coef^2);
  for i = 0:data.order_coef
    for j = 0:data.order_coef
      k(col) = data.k_alpha(tstep)^i*data.k_beta(tstep)^j;
      col = col+1;
    end
  end

