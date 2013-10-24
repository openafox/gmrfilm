c-------------------------------XRAY----------------------------
c
c     Returns the energy of the xray (in kev) for the requested
c     element and line. Data are stored in ev in a lookup table.
c     Some fortrans allow only 19 continuation lines, hence, the
c     5 arrays of 12x19 to hold the data (even though Ryan-McFarland
c     allows unlimited continuation lines).
c     Source: Handbook of Chemistry and Physics, 63rd Ed., CRC Press
c     4/87 r.a. waldo
c
      function xray(z,line)
      integer x0(12,10),x1(12,10),x2(12,10),x3(12,10),x4(12,10),
     &        x5(12,10),x6(12,10),x7(12,10),x8(12,10),x9(12,2)

c  Edges:     K           L1           L2         L3      M3  M4  M5
c  Lines:   Kb Ka   Lg2,3 Lb3 Lb4    Lg1 Lb1    Lb2 La1   Mg  Mb  Ma
c Array Pos: 1  2     3    4   5      6   7      8   9    10  11  12
c
      data x0/
     &0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &100, 100, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &183, 183, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &277, 277, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &392, 392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &525, 525, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &677, 677, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &858, 849, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0/
      data x1/
     &1071, 1041, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &1302, 1254, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &1557, 1487, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &1836, 1740, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &2139, 2014, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &2464, 2308, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &2816, 2622, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &3191, 2958, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &3590, 3314, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     &4013, 3692, 341, 341, 341, 341, 341, 341, 341, 0, 0, 0/
      data x2/
     &4461, 4091, 400, 400, 400, 400, 400, 395, 395, 0, 0, 0,
     &4932, 4511, 458, 458, 458, 458, 458, 452, 452, 0, 0, 0,
     &5427, 4952, 519, 519, 519, 519, 519, 511, 511, 0, 0, 0,
     &5947, 5415, 585, 585, 585, 583, 583, 573, 573, 0, 0, 0,
     &6490, 5899, 654, 654, 654, 649, 649, 637, 637, 0, 0, 0,
     &7058, 6403, 721, 721, 721, 719, 719, 705, 705, 0, 0, 0,
     &7649, 6930, 792, 792, 792, 791, 791, 776, 776, 0, 0, 0,
     &8265, 7478, 941, 941, 941, 869, 869, 852, 852, 0, 0, 0,
     &8905, 8048, 1023, 1023, 1023, 950, 950, 930, 930, 0, 0, 0,
     &9572, 8639, 1107, 1107, 1107, 1035, 1035, 1012, 1012, 0, 0, 0/
      data x3/
     &10264, 9252, 1197, 1197, 1197, 1125, 1125, 1098, 1098, 0, 0, 0,
     &10982, 9886, 1294, 1294, 1286, 1219, 1219, 1188, 1188, 0, 0, 0,
     &11726, 10544, 1388, 1388, 1388, 1317, 1317, 1282, 1282, 0, 0, 0,
     &12496, 11222, 1490, 1490, 1490, 1419, 1419, 1379, 1379, 0, 0, 0,
     &13291, 11924, 1596, 1596, 1596, 1526, 1526, 1480, 1480, 0, 0, 0,
     &14112, 12649, 1707, 1697, 1697, 1637, 1637, 1586, 1586, 0, 0, 0,
     &14961, 13395, 2051, 1827, 1818, 1752, 1752, 1694, 1694, 0, 0, 0,
     &15836, 14165, 2197, 1947, 1936, 1872, 1872, 1807, 1807, 0, 0, 0,
     &16738, 14958, 2347, 2072, 2060, 1996, 1996, 1923, 1923, 0, 0, 0,
     &17668, 15775, 2503, 2201, 2187, 2124, 2124, 2042, 2042, 0, 0, 0/
      data x4/
     &18623, 16615, 2664, 2335, 2319, 2462, 2257, 2367, 2166, 0, 0, 0,
     &19608, 17479, 2831, 2473, 2456, 2624, 2395, 2518, 2293, 0, 0, 0,
     &20619, 18367, 3000, 2605, 2592, 2792, 2537, 2630, 2424, 0, 0, 0,
     &21657, 19279, 3181, 2763, 2741, 2965, 2683, 2836, 2559, 0, 0, 0,
     &22724, 20216, 3364, 2916, 2891, 3144, 2834, 3001, 2697, 0, 0, 0,
     &23819, 21177, 3553, 3073, 3045, 3329, 2990, 3172, 2839, 0, 0, 0,
     &24942, 22163, 3746, 3234, 3203, 3520, 3151, 3348, 2984, 0, 0, 0,
     &26096, 23174, 3951, 3401, 3367, 3717, 3317, 3528, 3134, 0, 0, 0,
     &27276, 24210, 4161, 3573, 3535, 3921, 3487, 3714, 3287, 0, 0, 0,
     &28486, 25271, 4377, 3750, 3708, 4131, 3663, 3905, 3444, 0, 0, 0/
      data x5/
     &29726, 26359, 4600, 3933, 3886, 4348, 3844, 4101, 3605, 0, 0, 0,
     &30996, 27472, 4829, 4120, 4070, 4571, 4030, 4302, 3769, 0, 0, 0,
     &32295, 28612, 5066, 4313, 4258, 4801, 4221, 4508, 3938, 0, 0, 0,
     &33624, 29779, 5305, 4513, 4258, 5037, 4417, 4719, 4110, 0, 0, 0,
     &34987, 30973, 5546, 4717, 4649, 5280, 4620, 4936, 4287, 0, 0, 0,
     &36378, 32194, 5804, 4927, 4852, 5531, 4828, 5157, 4466, 0, 0, 0,
     &37801,33442,6067,5143,5062,5789, 5042, 5384, 4651, 1027, 854, 833,
     &39257,34720,6332,5365,5277,6052, 5262, 5613, 4840, 1075, 902, 883,
     &40748,36026,6607,5592,5498,6322, 5489, 5850, 5034, 1127, 950, 929,
     &42271,37361,6892,5829,5722,6602, 5722, 6089, 5230, 1180, 997, 978/
      data x6/
     &43826,38725,7185,6071,5957,6892,5961,6339, 5433, 1237, 1049, 1029,
     &45413,40118,7496,6318,6196,7178,6205,6587, 5636, 1291, 1100, 1081,
     &47038,41542,7782,6571,6439,7480,6456,6843, 5846, 1346, 1153, 1131,
     &48697,43000,8096,6831,6687,7786,6713,7103, 6057, 1402, 1209, 1185,
     &-1,44482,8410,7096,6940, 8102, 6978, 7367, 6273, 1461, 1266, 1240,
     &-1,45998,8733,7370,7204, 8419, 7248, 7636, 6495, 1522, 1325, 1293,
     &-1,47547,9069,7652,7471, 8747, 7525, 7911, 6720, 1576, 1383, 1348,
     &-1,49128,9417,7939,7745, 9089, 7811, 8189, 6949, 1643, 1443, 1406,
     &-1,-1, 9754, 8231, 8026, 9426, 8101, 8468, 7180, 1705, 1503, 1462,
     &-1,-1,10016, 8537, 8313, 9870, 8402, 8759, 7416, 1765, 1568, 1521/
      data x7/
     &-1,-1,10485,8847, 8606, 10143, 8709, 9044, 7656, 1832, 1631, 1581,
     &-1,-1,10861,9163, 8905, 10516, 9023, 9342, 7899, 1895, 1698, 1645,
     &-1,-1,11247,9488, 9212, 10895, 9343, 9645, 8146, 1964, 1766, 1710,
     &-1,-1,11641,9819, 9525, 11286, 9672, 9955, 8398, 2035, 1835, 1775,
     &-1,-1,12046,10160,9846,11685,10010, 10268, 8652, 2107, 1906, 1843,
     &-1,-1,12461,10511,10175,12095,10356,10591, 8912, 2182, 1978, 1910,
     &-1,-1,12883,10867,10511,12513,10708,10912, 9175, 2254, 2054, 1980,
     &-1,-1,13315,11231,10854,12942,11071,11240, 9442, 2331, 2127, 2051,
     &-1,-1,13759,11610,11205,13382,11442,11576, 9713, 2410, 2205, 2123,
     &-1,-1,14214,11995,11563,13830,11823,11914, 9989, 2488, 2283, 2195/
      data x8/
     &-1,-1,14681,12390,11931,14292,12213,12261,10269, 2571, 2362, 2271,
     &-1,-1,15159,12793,12306,14764,12614,12612,10552, 2653, 2443, 2346,
     &-1,-1,15646,13210,12691,15248,13024,12963,10839, 2735, 2526, 2423,
     &-1,-1,16144,13638,13086,15744,13447,13327,11131, 2819, 2611, 2501,
     &-1,-1,16653,14067,13482,16251,13876,13698,11427, 2906, 2695, 2580,
     &-1,-1,17173,14512,13989,16770,14316,14066,11727, 2994, 2781, 2659,
     &-1,-1,17704,14976,14307,17300,14770,14441,12031, 3085, 2871, 2741,
     &-1,-1,18268,15445,14747,17849,15236,14825,12340, 3178, 2961, 2824,
     &-1,-1,18830,15931,15198,18408,15713,15224,12652, 3274, 3053, 2909,
     &-1,-1,19406,16426,15643,18983,16202,15606,12969, 3370, 3146, 2996/
      data x9/
     &-1,-1,19985,16930,16104,19568,16702,16003,13291, 3466, 3240, 3082,
     &-1,-1,20599,17455,16575,20167,17220,16407,13615, 3563, 3337, 3171/
      nz=int(z)
      if (nz.le.10) then
        xray=x0(line,nz)/1000.
      else if (nz.le.20) then
        xray=x1(line,nz-10)/1000.
      else if (nz.le.30) then
        xray=x2(line,nz-20)/1000.
      else if (nz.le.40) then
        xray=x3(line,nz-30)/1000.
      else if (nz.le.50) then
        xray=x4(line,nz-40)/1000.
      else if (nz.le.60) then
        xray=x5(line,nz-50)/1000.
      else if (nz.le.70) then
        xray=x6(line,nz-60)/1000.
      else if (nz.le.80) then
        xray=x7(line,nz-70)/1000.
      else if (nz.le.90) then
        xray=x8(line,nz-80)/1000.
      else
        xray=x9(line,nz-90)/1000.
      endif
      if (xray.lt.0.) xray=50000.
      return
      end
