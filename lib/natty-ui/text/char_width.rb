# frozen_string_literal: true

module NattyUI
  module Text
    #
    # based on Unicode v16.0.0
    #
    module CharWidth
      def self.[](ord) = WIDTH[LAST.bsearch_index { ord <= _1 }]

      LAST = [
        0xa0,
        0xa1,
        0xa3,
        0xa4,
        0xa6,
        0xa8,
        0xa9,
        0xaa,
        0xac,
        0xae,
        0xaf,
        0xb4,
        0xb5,
        0xba,
        0xbb,
        0xbf,
        0xc5,
        0xc6,
        0xcf,
        0xd0,
        0xd6,
        0xd8,
        0xdd,
        0xe1,
        0xe5,
        0xe6,
        0xe7,
        0xea,
        0xeb,
        0xed,
        0xef,
        0xf0,
        0xf1,
        0xf3,
        0xf6,
        0xfa,
        0xfb,
        0xfc,
        0xfd,
        0xfe,
        0x100,
        0x101,
        0x110,
        0x111,
        0x112,
        0x113,
        0x11a,
        0x11b,
        0x125,
        0x127,
        0x12a,
        0x12b,
        0x130,
        0x133,
        0x137,
        0x138,
        0x13e,
        0x142,
        0x143,
        0x144,
        0x147,
        0x14b,
        0x14c,
        0x14d,
        0x151,
        0x153,
        0x165,
        0x167,
        0x16a,
        0x16b,
        0x1cd,
        0x1ce,
        0x1cf,
        0x1d0,
        0x1d1,
        0x1d2,
        0x1d3,
        0x1d4,
        0x1d5,
        0x1d6,
        0x1d7,
        0x1d8,
        0x1d9,
        0x1da,
        0x1db,
        0x1dc,
        0x250,
        0x251,
        0x260,
        0x261,
        0x2c3,
        0x2c4,
        0x2c6,
        0x2c7,
        0x2c8,
        0x2cb,
        0x2cc,
        0x2cd,
        0x2cf,
        0x2d0,
        0x2d7,
        0x2db,
        0x2dc,
        0x2dd,
        0x2de,
        0x2df,
        0x2ff,
        0x36f,
        0x390,
        0x3a1,
        0x3a2,
        0x3a9,
        0x3b0,
        0x3c1,
        0x3c2,
        0x3c9,
        0x400,
        0x401,
        0x40f,
        0x44f,
        0x450,
        0x451,
        0x482,
        0x487,
        0x590,
        0x5bd,
        0x5be,
        0x5bf,
        0x5c0,
        0x5c2,
        0x5c3,
        0x5c5,
        0x5c6,
        0x5c7,
        0x60f,
        0x61a,
        0x64a,
        0x65f,
        0x66f,
        0x670,
        0x6d5,
        0x6dc,
        0x6de,
        0x6e4,
        0x6e6,
        0x6e8,
        0x6e9,
        0x6ed,
        0x710,
        0x711,
        0x72f,
        0x74a,
        0x7a5,
        0x7b0,
        0x7ea,
        0x7f3,
        0x7fc,
        0x7fd,
        0x815,
        0x819,
        0x81a,
        0x823,
        0x824,
        0x827,
        0x828,
        0x82d,
        0x858,
        0x85b,
        0x896,
        0x89f,
        0x8c9,
        0x8e1,
        0x8e2,
        0x902,
        0x939,
        0x93a,
        0x93b,
        0x93c,
        0x940,
        0x948,
        0x94c,
        0x94d,
        0x950,
        0x957,
        0x961,
        0x963,
        0x980,
        0x981,
        0x9bb,
        0x9bc,
        0x9c0,
        0x9c4,
        0x9cc,
        0x9cd,
        0x9e1,
        0x9e3,
        0x9fd,
        0x9fe,
        0xa00,
        0xa02,
        0xa3b,
        0xa3c,
        0xa40,
        0xa42,
        0xa46,
        0xa48,
        0xa4a,
        0xa4d,
        0xa50,
        0xa51,
        0xa6f,
        0xa71,
        0xa74,
        0xa75,
        0xa80,
        0xa82,
        0xabb,
        0xabc,
        0xac0,
        0xac5,
        0xac6,
        0xac8,
        0xacc,
        0xacd,
        0xae1,
        0xae3,
        0xaf9,
        0xaff,
        0xb00,
        0xb01,
        0xb3b,
        0xb3c,
        0xb3e,
        0xb3f,
        0xb40,
        0xb44,
        0xb4c,
        0xb4d,
        0xb54,
        0xb56,
        0xb61,
        0xb63,
        0xb81,
        0xb82,
        0xbbf,
        0xbc0,
        0xbcc,
        0xbcd,
        0xbff,
        0xc00,
        0xc03,
        0xc04,
        0xc3b,
        0xc3c,
        0xc3d,
        0xc40,
        0xc45,
        0xc48,
        0xc49,
        0xc4d,
        0xc54,
        0xc56,
        0xc61,
        0xc63,
        0xc80,
        0xc81,
        0xcbb,
        0xcbc,
        0xcbe,
        0xcbf,
        0xcc5,
        0xcc6,
        0xccb,
        0xccd,
        0xce1,
        0xce3,
        0xcff,
        0xd01,
        0xd3a,
        0xd3c,
        0xd40,
        0xd44,
        0xd4c,
        0xd4d,
        0xd61,
        0xd63,
        0xd80,
        0xd81,
        0xdc9,
        0xdca,
        0xdd1,
        0xdd4,
        0xdd5,
        0xdd6,
        0xe30,
        0xe31,
        0xe33,
        0xe3a,
        0xe46,
        0xe4e,
        0xeb0,
        0xeb1,
        0xeb3,
        0xebc,
        0xec7,
        0xece,
        0xf17,
        0xf19,
        0xf34,
        0xf35,
        0xf36,
        0xf37,
        0xf38,
        0xf39,
        0xf70,
        0xf7e,
        0xf7f,
        0xf84,
        0xf85,
        0xf87,
        0xf8c,
        0xf97,
        0xf98,
        0xfbc,
        0xfc5,
        0xfc6,
        0x102c,
        0x1030,
        0x1031,
        0x1037,
        0x1038,
        0x103a,
        0x103c,
        0x103e,
        0x1057,
        0x1059,
        0x105d,
        0x1060,
        0x1070,
        0x1074,
        0x1081,
        0x1082,
        0x1084,
        0x1086,
        0x108c,
        0x108d,
        0x109c,
        0x109d,
        0x10ff,
        0x115f,
        0x135c,
        0x135f,
        0x1711,
        0x1714,
        0x1731,
        0x1733,
        0x1751,
        0x1753,
        0x1771,
        0x1773,
        0x17b3,
        0x17b5,
        0x17b6,
        0x17bd,
        0x17c5,
        0x17c6,
        0x17c8,
        0x17d3,
        0x17dc,
        0x17dd,
        0x180a,
        0x180d,
        0x180e,
        0x180f,
        0x1884,
        0x1886,
        0x18a8,
        0x18a9,
        0x191f,
        0x1922,
        0x1926,
        0x1928,
        0x1931,
        0x1932,
        0x1938,
        0x193b,
        0x1a16,
        0x1a18,
        0x1a1a,
        0x1a1b,
        0x1a55,
        0x1a56,
        0x1a57,
        0x1a5e,
        0x1a5f,
        0x1a60,
        0x1a61,
        0x1a62,
        0x1a64,
        0x1a6c,
        0x1a72,
        0x1a7c,
        0x1a7e,
        0x1a7f,
        0x1aaf,
        0x1abd,
        0x1abe,
        0x1ace,
        0x1aff,
        0x1b03,
        0x1b33,
        0x1b34,
        0x1b35,
        0x1b3a,
        0x1b3b,
        0x1b3c,
        0x1b41,
        0x1b42,
        0x1b6a,
        0x1b73,
        0x1b7f,
        0x1b81,
        0x1ba1,
        0x1ba5,
        0x1ba7,
        0x1ba9,
        0x1baa,
        0x1bad,
        0x1be5,
        0x1be6,
        0x1be7,
        0x1be9,
        0x1bec,
        0x1bed,
        0x1bee,
        0x1bf1,
        0x1c2b,
        0x1c33,
        0x1c35,
        0x1c37,
        0x1ccf,
        0x1cd2,
        0x1cd3,
        0x1ce0,
        0x1ce1,
        0x1ce8,
        0x1cec,
        0x1ced,
        0x1cf3,
        0x1cf4,
        0x1cf7,
        0x1cf9,
        0x1dbf,
        0x1dff,
        0x200f,
        0x2010,
        0x2012,
        0x2016,
        0x2017,
        0x2019,
        0x201b,
        0x201d,
        0x201f,
        0x2022,
        0x2023,
        0x2027,
        0x202f,
        0x2030,
        0x2031,
        0x2033,
        0x2034,
        0x2035,
        0x203a,
        0x203b,
        0x203d,
        0x203e,
        0x2073,
        0x2074,
        0x207e,
        0x207f,
        0x2080,
        0x2084,
        0x20ab,
        0x20ac,
        0x20cf,
        0x20dc,
        0x20e0,
        0x20e1,
        0x20e4,
        0x20f0,
        0x2102,
        0x2103,
        0x2104,
        0x2105,
        0x2108,
        0x2109,
        0x2112,
        0x2113,
        0x2115,
        0x2116,
        0x2120,
        0x2122,
        0x2125,
        0x2126,
        0x212a,
        0x212b,
        0x2152,
        0x2154,
        0x215a,
        0x215e,
        0x215f,
        0x216b,
        0x216f,
        0x2179,
        0x2188,
        0x2189,
        0x218f,
        0x2199,
        0x21b7,
        0x21b9,
        0x21d1,
        0x21d2,
        0x21d3,
        0x21d4,
        0x21e6,
        0x21e7,
        0x21ff,
        0x2200,
        0x2201,
        0x2203,
        0x2206,
        0x2208,
        0x220a,
        0x220b,
        0x220e,
        0x220f,
        0x2210,
        0x2211,
        0x2214,
        0x2215,
        0x2219,
        0x221a,
        0x221c,
        0x2220,
        0x2222,
        0x2223,
        0x2224,
        0x2225,
        0x2226,
        0x222c,
        0x222d,
        0x222e,
        0x2233,
        0x2237,
        0x223b,
        0x223d,
        0x2247,
        0x2248,
        0x224b,
        0x224c,
        0x2251,
        0x2252,
        0x225f,
        0x2261,
        0x2263,
        0x2267,
        0x2269,
        0x226b,
        0x226d,
        0x226f,
        0x2281,
        0x2283,
        0x2285,
        0x2287,
        0x2294,
        0x2295,
        0x2298,
        0x2299,
        0x22a4,
        0x22a5,
        0x22be,
        0x22bf,
        0x2311,
        0x2312,
        0x2319,
        0x231b,
        0x2328,
        0x232a,
        0x23e8,
        0x23ec,
        0x23ef,
        0x23f0,
        0x23f2,
        0x23f3,
        0x245f,
        0x24e9,
        0x24ea,
        0x254b,
        0x254f,
        0x2573,
        0x257f,
        0x258f,
        0x2591,
        0x2595,
        0x259f,
        0x25a1,
        0x25a2,
        0x25a9,
        0x25b1,
        0x25b3,
        0x25b5,
        0x25b7,
        0x25bb,
        0x25bd,
        0x25bf,
        0x25c1,
        0x25c5,
        0x25c8,
        0x25ca,
        0x25cb,
        0x25cd,
        0x25d1,
        0x25e1,
        0x25e5,
        0x25ee,
        0x25ef,
        0x25fc,
        0x25fe,
        0x2604,
        0x2606,
        0x2608,
        0x2609,
        0x260d,
        0x260f,
        0x2613,
        0x2615,
        0x261b,
        0x261c,
        0x261d,
        0x261e,
        0x262f,
        0x2637,
        0x263f,
        0x2640,
        0x2641,
        0x2642,
        0x2647,
        0x2653,
        0x265f,
        0x2661,
        0x2662,
        0x2665,
        0x2666,
        0x266a,
        0x266b,
        0x266d,
        0x266e,
        0x266f,
        0x267e,
        0x267f,
        0x2689,
        0x268f,
        0x2692,
        0x2693,
        0x269d,
        0x269f,
        0x26a0,
        0x26a1,
        0x26a9,
        0x26ab,
        0x26bc,
        0x26be,
        0x26bf,
        0x26c3,
        0x26c5,
        0x26cd,
        0x26ce,
        0x26d3,
        0x26d4,
        0x26e1,
        0x26e2,
        0x26e3,
        0x26e7,
        0x26e9,
        0x26ea,
        0x26f1,
        0x26f3,
        0x26f4,
        0x26f5,
        0x26f9,
        0x26fa,
        0x26fc,
        0x26fd,
        0x26ff,
        0x2704,
        0x2705,
        0x2709,
        0x270b,
        0x2727,
        0x2728,
        0x273c,
        0x273d,
        0x274b,
        0x274c,
        0x274d,
        0x274e,
        0x2752,
        0x2755,
        0x2756,
        0x2757,
        0x2775,
        0x277f,
        0x2794,
        0x2797,
        0x27af,
        0x27b0,
        0x27be,
        0x27bf,
        0x2b1a,
        0x2b1c,
        0x2b4f,
        0x2b50,
        0x2b54,
        0x2b55,
        0x2b59,
        0x2cee,
        0x2cf1,
        0x2d7e,
        0x2d7f,
        0x2ddf,
        0x2dff,
        0x2e7f,
        0x2e99,
        0x2e9a,
        0x2ef3,
        0x2eff,
        0x2fd5,
        0x2fef,
        0x3029,
        0x302d,
        0x303e,
        0x3040,
        0x3096,
        0x3098,
        0x309a,
        0x30ff,
        0x3104,
        0x312f,
        0x3130,
        0x318e,
        0x318f,
        0x31e5,
        0x31ee,
        0x321e,
        0x321f,
        0x3247,
        0x324f,
        0xa48c,
        0xa48f,
        0xa4c6,
        0xa66e,
        0xa66f,
        0xa673,
        0xa67d,
        0xa69d,
        0xa69f,
        0xa6ef,
        0xa6f1,
        0xa801,
        0xa802,
        0xa805,
        0xa806,
        0xa80a,
        0xa80b,
        0xa824,
        0xa826,
        0xa82b,
        0xa82c,
        0xa8c3,
        0xa8c5,
        0xa8df,
        0xa8f1,
        0xa8fe,
        0xa8ff,
        0xa925,
        0xa92d,
        0xa946,
        0xa951,
        0xa95f,
        0xa97c,
        0xa97f,
        0xa982,
        0xa9b2,
        0xa9b3,
        0xa9b5,
        0xa9b9,
        0xa9bb,
        0xa9bd,
        0xa9e4,
        0xa9e5,
        0xaa28,
        0xaa2e,
        0xaa30,
        0xaa32,
        0xaa34,
        0xaa36,
        0xaa42,
        0xaa43,
        0xaa4b,
        0xaa4c,
        0xaa7b,
        0xaa7c,
        0xaaaf,
        0xaab0,
        0xaab1,
        0xaab4,
        0xaab6,
        0xaab8,
        0xaabd,
        0xaabf,
        0xaac0,
        0xaac1,
        0xaaeb,
        0xaaed,
        0xaaf5,
        0xaaf6,
        0xabe4,
        0xabe5,
        0xabe7,
        0xabe8,
        0xabec,
        0xabed,
        0xabff,
        0xd7a3,
        0xdfff,
        0xf8ff,
        0xfaff,
        0xfb1d,
        0xfb1e,
        0xfdff,
        0xfe0f,
        0xfe19,
        0xfe1f,
        0xfe2f,
        0xfe52,
        0xfe53,
        0xfe66,
        0xfe67,
        0xfe6b,
        0xff00,
        0xff60,
        0xffdf,
        0xffe6,
        0xfffc,
        0xfffd,
        0x101fc,
        0x101fd,
        0x102df,
        0x102e0,
        0x10375,
        0x1037a,
        0x10a00,
        0x10a03,
        0x10a04,
        0x10a06,
        0x10a0b,
        0x10a0f,
        0x10a37,
        0x10a3a,
        0x10a3e,
        0x10a3f,
        0x10ae4,
        0x10ae6,
        0x10d23,
        0x10d27,
        0x10d68,
        0x10d6d,
        0x10eaa,
        0x10eac,
        0x10efb,
        0x10eff,
        0x10f45,
        0x10f50,
        0x10f81,
        0x10f85,
        0x11000,
        0x11001,
        0x11037,
        0x11046,
        0x1106f,
        0x11070,
        0x11072,
        0x11074,
        0x1107e,
        0x11081,
        0x110b2,
        0x110b6,
        0x110b8,
        0x110ba,
        0x110c1,
        0x110c2,
        0x110ff,
        0x11102,
        0x11126,
        0x1112b,
        0x1112c,
        0x11134,
        0x11172,
        0x11173,
        0x1117f,
        0x11181,
        0x111b5,
        0x111be,
        0x111c8,
        0x111cc,
        0x111ce,
        0x111cf,
        0x1122e,
        0x11231,
        0x11233,
        0x11234,
        0x11235,
        0x11237,
        0x1123d,
        0x1123e,
        0x11240,
        0x11241,
        0x112de,
        0x112df,
        0x112e2,
        0x112ea,
        0x112ff,
        0x11301,
        0x1133a,
        0x1133c,
        0x1133f,
        0x11340,
        0x11365,
        0x1136c,
        0x1136f,
        0x11374,
        0x113ba,
        0x113c0,
        0x113cd,
        0x113ce,
        0x113cf,
        0x113d0,
        0x113d1,
        0x113d2,
        0x113e0,
        0x113e2,
        0x11437,
        0x1143f,
        0x11441,
        0x11444,
        0x11445,
        0x11446,
        0x1145d,
        0x1145e,
        0x114b2,
        0x114b8,
        0x114b9,
        0x114ba,
        0x114be,
        0x114c0,
        0x114c1,
        0x114c3,
        0x115b1,
        0x115b5,
        0x115bb,
        0x115bd,
        0x115be,
        0x115c0,
        0x115db,
        0x115dd,
        0x11632,
        0x1163a,
        0x1163c,
        0x1163d,
        0x1163e,
        0x11640,
        0x116aa,
        0x116ab,
        0x116ac,
        0x116ad,
        0x116af,
        0x116b5,
        0x116b6,
        0x116b7,
        0x1171c,
        0x1171d,
        0x1171e,
        0x1171f,
        0x11721,
        0x11725,
        0x11726,
        0x1172b,
        0x1182e,
        0x11837,
        0x11838,
        0x1183a,
        0x1193a,
        0x1193c,
        0x1193d,
        0x1193e,
        0x11942,
        0x11943,
        0x119d3,
        0x119d7,
        0x119d9,
        0x119db,
        0x119df,
        0x119e0,
        0x11a00,
        0x11a0a,
        0x11a32,
        0x11a38,
        0x11a3a,
        0x11a3e,
        0x11a46,
        0x11a47,
        0x11a50,
        0x11a56,
        0x11a58,
        0x11a5b,
        0x11a89,
        0x11a96,
        0x11a97,
        0x11a99,
        0x11c2f,
        0x11c36,
        0x11c37,
        0x11c3d,
        0x11c3e,
        0x11c3f,
        0x11c91,
        0x11ca7,
        0x11ca9,
        0x11cb0,
        0x11cb1,
        0x11cb3,
        0x11cb4,
        0x11cb6,
        0x11d30,
        0x11d36,
        0x11d39,
        0x11d3a,
        0x11d3b,
        0x11d3d,
        0x11d3e,
        0x11d45,
        0x11d46,
        0x11d47,
        0x11d8f,
        0x11d91,
        0x11d94,
        0x11d95,
        0x11d96,
        0x11d97,
        0x11ef2,
        0x11ef4,
        0x11eff,
        0x11f01,
        0x11f35,
        0x11f3a,
        0x11f3f,
        0x11f40,
        0x11f41,
        0x11f42,
        0x11f59,
        0x11f5a,
        0x1343f,
        0x13440,
        0x13446,
        0x13455,
        0x1611d,
        0x16129,
        0x1612c,
        0x1612f,
        0x16aef,
        0x16af4,
        0x16b2f,
        0x16b36,
        0x16f4e,
        0x16f4f,
        0x16f8e,
        0x16f92,
        0x16fdf,
        0x16fe3,
        0x16fe4,
        0x16fef,
        0x16ff1,
        0x16fff,
        0x187f7,
        0x187ff,
        0x18cd5,
        0x18cfe,
        0x18d08,
        0x1afef,
        0x1aff3,
        0x1aff4,
        0x1affb,
        0x1affc,
        0x1affe,
        0x1afff,
        0x1b122,
        0x1b131,
        0x1b132,
        0x1b14f,
        0x1b152,
        0x1b154,
        0x1b155,
        0x1b163,
        0x1b167,
        0x1b16f,
        0x1b2fb,
        0x1bc9c,
        0x1bc9e,
        0x1ceff,
        0x1cf2d,
        0x1cf2f,
        0x1cf46,
        0x1d166,
        0x1d169,
        0x1d17a,
        0x1d182,
        0x1d184,
        0x1d18b,
        0x1d1a9,
        0x1d1ad,
        0x1d241,
        0x1d244,
        0x1d2ff,
        0x1d356,
        0x1d35f,
        0x1d376,
        0x1d9ff,
        0x1da36,
        0x1da3a,
        0x1da6c,
        0x1da74,
        0x1da75,
        0x1da83,
        0x1da84,
        0x1da9a,
        0x1da9f,
        0x1daa0,
        0x1daaf,
        0x1dfff,
        0x1e006,
        0x1e007,
        0x1e018,
        0x1e01a,
        0x1e021,
        0x1e022,
        0x1e024,
        0x1e025,
        0x1e02a,
        0x1e08e,
        0x1e08f,
        0x1e12f,
        0x1e136,
        0x1e2ad,
        0x1e2ae,
        0x1e2eb,
        0x1e2ef,
        0x1e4eb,
        0x1e4ef,
        0x1e5ed,
        0x1e5ef,
        0x1e8cf,
        0x1e8d6,
        0x1e943,
        0x1e94a,
        0x1f003,
        0x1f004,
        0x1f0ce,
        0x1f0cf,
        0x1f0ff,
        0x1f10a,
        0x1f10f,
        0x1f12d,
        0x1f12f,
        0x1f169,
        0x1f16f,
        0x1f18d,
        0x1f18e,
        0x1f190,
        0x1f19a,
        0x1f1ac,
        0x1f1e5,
        0x1f202,
        0x1f20f,
        0x1f23b,
        0x1f23f,
        0x1f248,
        0x1f24f,
        0x1f251,
        0x1f25f,
        0x1f265,
        0x1f2ff,
        0x1f320,
        0x1f32c,
        0x1f335,
        0x1f336,
        0x1f37c,
        0x1f37d,
        0x1f393,
        0x1f39f,
        0x1f3ca,
        0x1f3ce,
        0x1f3d3,
        0x1f3df,
        0x1f3f0,
        0x1f3f3,
        0x1f3f4,
        0x1f3f7,
        0x1f43e,
        0x1f43f,
        0x1f440,
        0x1f441,
        0x1f4fc,
        0x1f4fe,
        0x1f53d,
        0x1f54a,
        0x1f54e,
        0x1f54f,
        0x1f567,
        0x1f579,
        0x1f57a,
        0x1f594,
        0x1f596,
        0x1f5a3,
        0x1f5a4,
        0x1f5fa,
        0x1f64f,
        0x1f67f,
        0x1f6c5,
        0x1f6cb,
        0x1f6cc,
        0x1f6cf,
        0x1f6d2,
        0x1f6d4,
        0x1f6d7,
        0x1f6db,
        0x1f6df,
        0x1f6ea,
        0x1f6ec,
        0x1f6f3,
        0x1f6fc,
        0x1f7df,
        0x1f7eb,
        0x1f7ef,
        0x1f7f0,
        0x1f90b,
        0x1f93a,
        0x1f93b,
        0x1f945,
        0x1f946,
        0x1f9ff,
        0x1fa6f,
        0x1fa7c,
        0x1fa7f,
        0x1fa89,
        0x1fa8e,
        0x1fac6,
        0x1facd,
        0x1fadc,
        0x1fade,
        0x1fae9,
        0x1faef,
        0x1faf8,
        0x1ffff,
        0x2fffd,
        0x2ffff,
        0x3fffd,
        0xe00ff,
        0xe01ef,
        0xeffff,
        0xffffd,
        0xfffff,
        0x10fffd,
        0x7fffffff
      ].freeze

      WIDTH = [
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        0,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        2,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        2,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        2,
        1,
        -1,
        1,
        -1,
        1,
        2,
        1,
        -1,
        1,
        -1,
        1,
        2,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        -1,
        1,
        2,
        1,
        2,
        1,
        2,
        -1,
        1,
        2,
        -1,
        2,
        -1,
        2,
        -1,
        1,
        -1,
        1,
        -1,
        2,
        -1,
        2,
        -1,
        2,
        -1,
        2,
        -1,
        2,
        -1,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        -1,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        -1,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        -1,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        0,
        2,
        1,
        2,
        1,
        0,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        -1,
        2,
        1,
        2,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        2,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        2,
        1,
        -1,
        2,
        1,
        0,
        1,
        0,
        2,
        1,
        0,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        -1,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        2,
        0,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        2,
        1,
        2,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        0,
        1,
        2,
        1,
        2,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        1,
        -1,
        2,
        -1,
        2,
        -1,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        2,
        1,
        0,
        1,
        -1,
        1,
        -1,
        1
      ].freeze
    end
  end
end