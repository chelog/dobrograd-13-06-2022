function REN.GTA4ColorTable2(Col1,Col2,Col3,Col4)

Cols = {}

--GTA4's 'carcols.dat' file reformatted into a lua table,
--for easy editing and calling colors on all vehicles.

--BLACK's
Cols[0] = Color(10,10,10)					-- 0 black
Cols[1] = Color(37,37,39)					-- 1 black poly
--GREYS/SILVERS
Cols[2] = Color(101,106,121)					-- 2 concord blue poly
Cols[3] = Color(88,89,90)					-- 3 pewter gray poly
Cols[4] = Color(156,161,163)					-- 4 silver stone poly
Cols[5] = Color(150,145,140)					-- 5 winning silver poly
Cols[6] = Color(81,84,89)					-- 6 steel gray poly
Cols[7] = Color(63,62,69)					-- 7 shadow silver poly
Cols[8] = Color(165,169,167)					-- 8 silver stone poly
Cols[9] = Color(151,149,146)					-- 9 porcelain silver poly
Cols[10] = Color(118,123,124)					-- 10 gray poly
Cols[11] = Color(90,87,82)					-- 11 anthracite gray poly
Cols[12] = Color(173,176,176)					-- 12 astra silver poly
Cols[13] = Color(132,137,136)					-- 13 ascot gray
Cols[14] = Color(148,157,159)					-- 14 clear crystal blue frost poly
Cols[15] = Color(164,167,165)					-- 15 silver poly
Cols[16] = Color(88,88,83)				-- 16 dk.titanium poly
Cols[17] = Color(164,160,150)					-- 17 titanium frost poly
Cols[18] = Color(175,177,177)					-- 18 police white
Cols[19] = Color(109,108,110)					-- 19 medium gray poly
Cols[20] = Color(100,104,106)					-- 20 med.gray poly
Cols[21] = Color(82,86,97)				-- 21 steel gray poly
Cols[22] = Color(140,146,154)					-- 22 slate gray
Cols[23] = Color(91,93,94)				-- 23 gun metal poly
Cols[24] = Color(189,190,198)					-- 24 light blue grey
Cols[25] = Color(182,182,182)					-- 25 securicor light gray
Cols[26] = Color(100,100,100)					-- 26 arctic white

--RED
Cols[27] = Color(226,6,6)						-- 27 very red
Cols[28] = Color(150,8,0)						-- 28 torino red pearl
Cols[29] = Color(107,0,0)						-- 29 formula red
Cols[30] = Color(97,16,9)						-- 30 blaze red
Cols[31] = Color(74,10,10)					-- 31 graceful red mica
Cols[32] = Color(115,11,11)					-- 32 garnet red poly
Cols[33] = Color(87,7,7)						-- 33 desert red
Cols[34] = Color(38,3,6)						-- 34 cabernet red poly
Cols[35] = Color(158,0,0)						-- 35 turismo red
Cols[36] = Color(20,0,2)						-- 36 desert red
Cols[37] = Color(15,4,4)						-- 37 currant red solid
Cols[38] = Color(15,8,10)						-- 38 brt.currant red poly
Cols[39] = Color(57,25,29)					-- 39 elec.currant red poly
Cols[40] = Color(85,39,37)					-- 40 med.cabernet solid
Cols[41] = Color(76,41,41)					-- 41 wild strawberry poly
Cols[42] = Color(116,29,40)					-- 42 med.red solid
Cols[43] = Color(109,40,55)					-- 43 bright red
Cols[44] = Color(115,10,39)					-- 44 bright red
Cols[45] = Color(100,13,27)					-- 45 med.garnet red poly
Cols[46] = Color(98,11,28)					-- 46 brilliant red poly
Cols[47] = Color(115,24,39)					-- 47 brilliant red poly2
Cols[48] = Color(171,152,143)					-- 48 alabaster solid
Cols[49] = Color(32,32,44)					-- 49 twilight blue poly

--GREEN
Cols[50] = Color(68,98,79)					-- 50 torch red
Cols[51] = Color(46,91,32)					-- 51 green
Cols[52] = Color(30,46,50)					-- 52 deep jewel green
Cols[53] = Color(48,79,69)					-- 53 agate green
Cols[54] = Color(77,98,104)					-- 54 petrol blue green poly
Cols[55] = Color(94,112,114)					-- 55 hoods
Cols[56] = Color(25,56,38)					-- 56 green
Cols[57] = Color(45,58,53)					-- 57 dark green poly
Cols[58] = Color(51,95,63)					-- 58 rio red
Cols[59] = Color(71,120,60)					-- 59 securicor dark green
Cols[60] = Color(147,163,150)					-- 60 seafoam poly
Cols[61] = Color(154,167,144)					-- 61 pastel alabaster solid

--BLUE
Cols[62] = Color(38,55,57)					-- 62 midnight blue
Cols[63] = Color(76,117,183)				-- 63 striking blue
Cols[64] = Color(70,89,122)					-- 64 saxony blue poly
Cols[65] = Color(93,126,141)					-- 65 jasper green poly
Cols[66] = Color(59,78,120)					-- 66 mariner blue
Cols[67] = Color(61,74,104)					-- 67 harbor blue poly
Cols[68] = Color(109,122,136)					-- 68 diamond blue poly
Cols[69] = Color(22,34,72)					-- 69 surf blue
Cols[70] = Color(39,47,75)					-- 70 nautical blue poly
Cols[71] = Color(78,104,129)					-- 71 lt.crystal blue poly
Cols[72] = Color(106,122,140)					-- 72 med regatta blue poly
Cols[73] = Color(111,130,151)					-- 73 spinnaker blue solid
Cols[74] = Color(14,49,109)					-- 74 ultra blue poly
Cols[75] = Color(57,90,131)					-- 75 bright blue poly
Cols[76] = Color(32,75,107)					-- 76 nassau blue poly
Cols[77] = Color(43,62,87)					-- 77 med.sapphire blue poly
Cols[78] = Color(54,65,85)					-- 78 steel blue poly
Cols[79] = Color(108,132,149)					-- 79 lt.sapphire blue poly
Cols[80] = Color(77,93,96)					-- 80 malachite poly
Cols[81] = Color(64,108,143)					-- 81 med.maui blue poly
Cols[82] = Color(19,69,115)					-- 82 bright blue poly
Cols[83] = Color(16,80,130)					-- 83 bright blue poly
Cols[84] = Color(56,86,148)					-- 84 blue
Cols[85] = Color(0,28,50)						-- 85 dk.sapphire blue poly
Cols[86] = Color(89,110,135)					-- 86 lt.sapphire blue poly
Cols[87] = Color(34,52,87)					-- 87 med.sapphire blue firemist
Cols[88] = Color(32,32,44)					-- 88 twilight blue poly

--YELLOW
Cols[89] = Color(245,137,15)					-- 89 taxi yellow
Cols[90] = Color(145,115,71)					-- 90 race yellow solid
Cols[91] = Color(142,140,70)					-- 91 pastel alabaster
Cols[92] = Color(170,173,142)					-- 92 oxford white solid
Cols[93] = Color(174,155,127)					-- 93 flax
Cols[94] = Color(150,129,108)					-- 94 med.flax
Cols[95] = Color(122,117,96)					-- 95 pueblo beige
Cols[96] = Color(157,152,114)					-- 96 light ivory
Cols[97] = Color(152,149,134)					-- 97 smoke silver poly
Cols[98] = Color(156,141,113)					-- 98 bisque frost poly

--ORANGE

--PURPLE
Cols[99] = Color(105,30,59)					-- 99 classic red
Cols[100] = Color(114,42,63)					-- 100 vermilion solid
Cols[101] = Color(124,27,68)					-- 101 vermillion solid

--BROWN
Cols[102] = Color(34,25,24)					-- 102 biston brown poly
Cols[103] = Color(127,105,86)					-- 103 lt.beechwood poly
Cols[104] = Color(71,53,50)					-- 104 dk.beechwood poly
Cols[105] = Color(105,88,83)					-- 105 dk.sable poly
Cols[106] = Color(98,68,40)					-- 106 med.beechwood poly
Cols[107] = Color(125,98,86)					-- 107 woodrose poly
Cols[108] = Color(170,157,132)					-- 108 sandalwood frost poly
Cols[109] = Color(123,113,94)					-- 109 med.sandalwood poly
Cols[110] = Color(171,146,118)					-- 110 copper beige
Cols[111] = Color(99,92,90)					-- 111 warm grey mica

--WHITE
Cols[112] = Color(201,201,201)					-- 112 white
Cols[113] = Color(214,218,214)					-- 113 frost white
Cols[114] = Color(159,157,148)					-- 114 honey beige poly
Cols[115] = Color(147,163,150)					-- 115 seafoam poly
Cols[116] = Color(156,156,152)					-- 116 lt.titanium poly
Cols[117] = Color(167,162,143)					-- 117 lt.champagne poly
Cols[118] = Color(15,106,137)					-- 118 arctic pearl

Cols[119] = Color(161,153,131)					-- 119 lt.driftwood poly
Cols[120] = Color(163,173,198)					-- 120 white diamond pearl
Cols[121] = Color(155,139,128)					-- 121 antelope beige
Cols[122] = Color(132,148,171)					-- 122 currant blue poly
Cols[123] = Color(158,164,171)					-- 123 crystal blue poly
--PURPLE

--SPEC FLIP COLOURS
Cols[124] = Color(134,68,110)					-- 124 temple curtain purple
Cols[125] = Color(226,6,6)						-- 125 cherry red
Cols[126] = Color(71,120,60)					-- 126 securicor dark green
Cols[127] = Color(215,142,16)					-- 127 taxi yellow
Cols[128] = Color(42,119,161)					-- 128 police car blue

--MSC
Cols[129] = Color(66,31,33)					-- 129 mellow burgundy
Cols[130] = Color(111,103,95)					-- 130 desert taupe poly
Cols[131] = Color(252,38,0)					-- 131 lammy orange
Cols[132] = Color(252,109,0)					-- 132 lammy yellow
Cols[133] = Color(255,255,255)					-- 133 very white

return Cols[Col1],Cols[Col2],Cols[Col3],Cols[Col4] end