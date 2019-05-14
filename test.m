h = rand(1,3);

Hc = [h(1) 0 0 h(3) h(2);
      h(2) h(1) 0 0 h(3);
      h(3) h(2) h(1) 0 0;
      0 h(3) h(2) h(1) 0;
      0 0 h(3) h(2) h(1)];
W = dftmtx(5)/sqrt(5);
L = W*Hc*W';
l = W*[h.';0;0]*sqrt(5);