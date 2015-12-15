function coef = razvoj(p)
  % vrne koeficiente v razvoju polinoma po polinomih cebiseva
  deg = length(p)-1;
  coef = zeros(1, deg+1);
  for i = deg+1:-1:1
    ch = chebishev(i-1);
    coef(deg+2-i) = p(1) / ch(1);
    p = p - coef(deg+2-i) * ch;
    p = p(2:end);
  end
end

% vim: set ft=matlab:
