// lib/data/catalogue.dart
// Full Cartier catalogue — 6 categories, 37 subcategories, 27 products each

class Product {
  final String id;
  final String name;
  final String collection;
  final double price;
  final String imageUrl;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.collection,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  String get formattedPrice {
    final p = price.toInt();
    final s = p.toString();
    final buf = StringBuffer('\$');
    final offset = s.length % 3;
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (i - offset) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class SubCategory {
  final String id;
  final String name;
  final List<Product> products;

  SubCategory({
    required this.id,
    required this.name,
    required this.products,
  });

  int get itemCount => products.length;
}

class MainCategory {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<SubCategory> subCategories;

  MainCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.subCategories,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Catalogue
// ─────────────────────────────────────────────────────────────────────────────

class Catalogue {
  Catalogue._();

  // ── 27 unique Unsplash URLs per category ────────────────────────────────

  static const _imgJewel = [
    'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1599643477877-530eb83abc8e?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1602173574767-37ac01994b2a?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1608042314453-ae338d80c427?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1506630268827-63cff8521e98?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1617038260897-41a1f14a8ca0?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1589128777073-263566ae5e4d?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1630349093880-23a5021e12f6?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1573408301185-9519f8c4e5db?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1568944650822-7db66c5b6b03?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1596944924616-7b38e7cfac36?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1619119069152-a2b331eb392a?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1612637968894-660373e23b03?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1622464117614-69e22c6b0c71?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1601121141499-bf42b04a1766?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1635767798638-3e25273a8236?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1593795899768-947c4929449d?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1616697748425-29a6f5a5e3f8?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1567222939931-25bea4ead78f?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1609873814058-a8928924184a?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1588776814546-1b3a8a3e5e87?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1598560917505-59a3ad559071?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1610747402024-a3d23a2b0a7d?w=600&fit=crop&q=80',
  ];

  static const _imgWatch = [
    'https://images.unsplash.com/photo-1524592094714-0f0654e359fc?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1547996160-81dfa63595aa?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1526045612212-70caf35c14df?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1585386959604-a3214db48e1b?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1622434641406-a158123450f9?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1618220179428-22790b461013?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1625614014492-fca793e40699?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1632625756524-f79e052a6a7c?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1636491516478-5792c5e2c895?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1509048191080-d2984bad6ae5?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1548171915-e79a380a2a4b?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1594534475808-b18fc33b045e?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1600080972464-8e5f35f63d08?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1612817288484-6f916006741a?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1619946794135-5bc917a27793?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1623998021450-85c29f787586?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1587836374828-f1670e5b1c3a?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1617591554941-5e31e8a94e31?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1611038419175-a7c62f6d2b37?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1569429593410-b498b3fb3387?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1591533700736-2cf3cf4c57b7?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1604242692760-2f7b0c26856d?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1639331404067-bc2bf7a65bc2?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1641909459481-49a05bec3bf5?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1642543492481-44e81e3914a7?w=600&fit=crop&q=80',
  ];

  static const _imgBag = [
    'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1584917865442-2b7c0dfd7f7b?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1591561954555-07991d90adeb?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1566150905458-1bf1fc113f0d?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1614179924047-e1ab49a0a0cf?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1600950207944-0d63e8edbc3f?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1547949003-9792a18a2601?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1578932750294-f5075e85f44a?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1612423284934-2850a4ea6b0f?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1510519138101-570d1dca3d66?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1575032617751-6ddec2089882?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1561861422-a549073e547a?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1559563362-c667ba5f5480?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1594938298603-c8148c4b4e38?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1588099768531-a72d4a198538?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1540221652346-e5dd6b50f3e7?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1548036329-b8feedd0b849?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1597633125184-3e6ee0bda1c3?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1614676471928-2ed0ad1061a4?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1473188608393-b9fc8f11e4b5?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1584917865442-2b7c0dfd7f7b?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=600&fit=crop&q=80',
  ];

  static const _imgFrag = [
    'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1541643600914-78b084683702?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1563170352-338fc1d60b34?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1615634260167-c8cdea21db0b?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1585386959604-a3214db48e1b?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1557170334-a9632e77c6e4?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1594035910387-fea47794261f?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1547824468-f54aaaa6a1f0?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1625021659159-9b5d2e7b1ef1?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1608528577891-eb055944f2e7?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1590156562745-5d0e7e32a87f?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1587017539504-67cfbddac569?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1619451683749-a762cc0eca89?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1601612628452-9e99ced43524?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1583467875263-d50b037a5571?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1566977776052-6e61e35bf9be?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1600612253971-1e6e2b9a8ade?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1587729927069-f54da9c16e98?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1551489186-cf8726f514f8?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1616949816878-97fcab6e9b64?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1631282715756-0b0ca3534413?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1619451683749-a762cc0eca89?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1599843786656-3c8c6def3cf5?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1603971468023-83c58d3d1e61?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1585386959604-a3214db48e1b?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1547996160-81dfa63595aa?w=600&fit=crop&q=80',
  ];

  static const _imgHome = [
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1484101403633-562f891dc89a?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1583394293253-535d0c8a2e82?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1456735190827-d1262f71b8a3?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1601297183305-6df142704ea2?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1600861194802-a2b11076bc51?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1564078516393-cf04bd966897?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1603201667141-5a2d4c673a86?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1545127398-14699f92334b?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1560343776-97e7d202ff0e?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1585435557343-3b092031a831?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=600&fit=crop&q=80',
    'https://images.unsplash.com/photo-1511556820780-d912e42b4980?w=600&fit=crop&q=80',
  ];

  // ── Product generator ───────────────────────────────────────────────────

  static List<Product> _gen({
    required String prefix,
    required List<String> names,
    required List<String> imgs,
    required double basePrice,
    double step = 500,
  }) {
    const desc =
        'A masterpiece of Cartier savoir-faire, this creation embodies the '
        "Maison's commitment to exceptional craftsmanship and timeless elegance.";
    return List.generate(27, (i) {
      final name = i < names.length
          ? names[i]
          : '${names[i % names.length]} — Edition ${_roman(i - names.length + 2)}';
      return Product(
        id: '${prefix}_$i',
        name: name,
        collection: prefix,
        price: basePrice + (i * step),
        imageUrl: imgs[i % imgs.length],
        description: desc,
      );
    });
  }

  static String _roman(int n) {
    if (n <= 0) return 'I';
    const vals = [10, 9, 5, 4, 1];
    const syms = ['X', 'IX', 'V', 'IV', 'I'];
    var result = '';
    var num = n;
    for (int i = 0; i < vals.length; i++) {
      while (num >= vals[i]) {
        result += syms[i];
        num -= vals[i];
      }
    }
    return result;
  }

  // ── Full catalogue ──────────────────────────────────────────────────────

  static final List<MainCategory> categories = [

    // ── 1. HIGH JEWELLERY ──────────────────────────────────────────────────
    MainCategory(
      id: 'high_jewellery',
      name: 'HIGH JEWELLERY',
      description:
          "Step into the world of Cartier High Jewellery and discover the dazzling energy that brings this creative canvas to life.",
      imageUrl:
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=900&fit=crop&q=80',
      subCategories: [
        SubCategory(
          id: 'hj_all',
          name: 'All Creations',
          products: _gen(
            prefix: 'hj_all',
            names: ['Panthère Émeraude Necklace', 'Indomptables Bracelet', 'Flora & Fauna Ring', 'Reflection of a Legend Brooch', 'Geometry & Contrasts Set', 'Living Legacy Tiara', 'Exceptional Stones Pendant', 'Les Éblouissants Earrings'],
            imgs: _imgJewel, basePrice: 45000, step: 12000,
          ),
        ),
        SubCategory(
          id: 'hj_latest',
          name: 'Latest Collections',
          products: _gen(
            prefix: 'hj_latest',
            names: ['Indomptables Necklace', 'Flora & Fauna Bracelet', 'Markers of Style Ring', 'Living Legacy Earrings', 'Reflection Pendant', 'Panthère Brooch', 'Geometric Ring', 'New Season Tiara'],
            imgs: _imgJewel, basePrice: 55000, step: 15000,
          ),
        ),
        SubCategory(
          id: 'hj_markers',
          name: 'Markers of Style',
          products: _gen(
            prefix: 'hj_markers',
            names: ['Style Icon Necklace', 'Iconic Bracelet', 'Heritage Ring', 'Signature Earrings', 'Statement Pendant', 'Timeless Choker', 'Classic Bangle', 'Panthère Brooch'],
            imgs: _imgJewel, basePrice: 38000, step: 9000,
          ),
        ),
        SubCategory(
          id: 'hj_panthere',
          name: 'Iconic Panthère',
          products: _gen(
            prefix: 'hj_panthere',
            names: ['Panthère Necklace Emerald', 'Panthère Ring Diamond', 'Panthère Bracelet Onyx', 'Panthère Brooch Sapphire', 'Panthère Earrings Gold', 'Panthère Pendant', 'Panthère Bangle', 'Panthère Choker'],
            imgs: _imgJewel, basePrice: 60000, step: 20000,
          ),
        ),
        SubCategory(
          id: 'hj_legacy',
          name: 'Living Legacy',
          products: _gen(
            prefix: 'hj_legacy',
            names: ['Legacy Necklace', 'Heritage Bracelet', 'Ancestral Ring', 'Timeless Earrings', 'Dynasty Pendant', 'Heirloom Brooch', 'Classic Legacy Ring', 'Maison Heritage Piece'],
            imgs: _imgJewel, basePrice: 50000, step: 18000,
          ),
        ),
        SubCategory(
          id: 'hj_stones',
          name: 'Exceptional Stones',
          products: _gen(
            prefix: 'hj_stones',
            names: ['Colombian Emerald Ring', 'Burma Ruby Necklace', 'Kashmir Sapphire Bracelet', 'Pink Diamond Earrings', 'Paraiba Tourmaline Ring', 'Alexandrite Pendant', 'Padparadscha Ring', 'Blue Diamond Brooch'],
            imgs: _imgJewel, basePrice: 80000, step: 30000,
          ),
        ),
        SubCategory(
          id: 'hj_knowhow',
          name: 'Know-How',
          products: _gen(
            prefix: 'hj_knowhow',
            names: ['Pavé Diamond Necklace', 'Hand-Engraved Bracelet', 'Gem-Setting Ring', 'Milgrain Earrings', 'Filigree Pendant', 'Granulation Brooch', 'Repoussé Bangle', 'Inlay Masterpiece'],
            imgs: _imgJewel, basePrice: 42000, step: 11000,
          ),
        ),
      ],
    ),

    // ── 2. JEWELLERY ───────────────────────────────────────────────────────
    MainCategory(
      id: 'jewellery',
      name: 'JEWELLERY',
      description:
          "Rings, bracelets, earrings and necklaces: Cartier's jewellery creations always have style.",
      imageUrl:
          'https://images.unsplash.com/photo-1573408301185-9519f8c4e5db?w=900&fit=crop&q=80',
      subCategories: [
        SubCategory(
          id: 'j_all',
          name: 'All Collections',
          products: _gen(
            prefix: 'j_all',
            names: ['LOVE Collection', 'Trinity Collection', 'Panthère Collection', 'Juste un Clou', 'Clash de Cartier', 'C de Cartier', 'Étincelle Collection', "Cartier d'Amour", 'Amulette de Cartier', 'Maillon Panthère'],
            imgs: _imgJewel, basePrice: 1500, step: 600,
          ),
        ),
        SubCategory(
          id: 'j_bracelets',
          name: 'Bracelets',
          products: _gen(
            prefix: 'j_bracelets',
            names: ['Love Bracelet', 'Juste un Clou Bracelet', 'Trinity Bracelet', 'Panthère de Cartier Bracelet', 'LOVE Bracelet Pavé', "Cartier d'Amour Bracelet", 'Étincelle de Cartier Bracelet', 'Clash de Cartier Bracelet', 'C de Cartier Bracelet', 'Maillon Panthère Bracelet'],
            imgs: _imgJewel, basePrice: 2100, step: 800,
          ),
        ),
        SubCategory(
          id: 'j_rings',
          name: 'Rings',
          products: _gen(
            prefix: 'j_rings',
            names: ['Love Ring', 'Solitaire 1895', 'Cartier Destinée Ring', 'Trinity Ring', 'Juste un Clou Ring', 'Panthère de Cartier Ring', 'LOVE Ring Pavé', 'Clash de Cartier Ring', 'Étincelle Ring', 'C de Cartier Ring'],
            imgs: _imgJewel, basePrice: 1600, step: 600,
          ),
        ),
        SubCategory(
          id: 'j_necklaces',
          name: 'Necklaces',
          products: _gen(
            prefix: 'j_necklaces',
            names: ['Love Necklace', 'Juste un Clou Necklace', 'Trinity Necklace', 'Panthère Necklace', 'Étincelle Necklace', "Cartier d'Amour Necklace", 'Amulette de Cartier', 'LOVE Pendant', 'C de Cartier Necklace', 'Clash de Cartier Necklace'],
            imgs: _imgJewel, basePrice: 1800, step: 700,
          ),
        ),
        SubCategory(
          id: 'j_earrings',
          name: 'Earrings',
          products: _gen(
            prefix: 'j_earrings',
            names: ['Love Earrings', 'Trinity Earrings', 'Panthère Earrings', 'Juste un Clou Earrings', 'Clash de Cartier Earrings', 'Étincelle Earrings', 'C de Cartier Earrings', "Cartier d'Amour Earrings", 'Amulette Earrings', 'Vendôme Louis Cartier Earrings'],
            imgs: _imgJewel, basePrice: 1500, step: 500,
          ),
        ),
        SubCategory(
          id: 'j_engagement',
          name: 'Engagement Rings',
          products: _gen(
            prefix: 'j_engagement',
            names: ['Solitaire 1895', 'Cartier Destinée', 'Étincelle Solitaire', 'Love Solitaire', "Cartier d'Amour Solitaire", 'Ballerine Solitaire', 'Vintage Solitaire', 'Trinity Solitaire', '1895 Platinum', 'Destinée Pavé'],
            imgs: _imgJewel, basePrice: 4500, step: 1500,
          ),
        ),
        SubCategory(
          id: 'j_wedding',
          name: 'Wedding Bands',
          products: _gen(
            prefix: 'j_wedding',
            names: ['Love Wedding Band', 'Trinity Wedding Band', "Cartier d'Amour Band", '1895 Wedding Band', 'Ballerine Wedding Band', 'Vendôme Band', 'LOVE Band Pavé', 'Étincelle Band', 'Maillon Band', 'Clash Band'],
            imgs: _imgJewel, basePrice: 1400, step: 400,
          ),
        ),
      ],
    ),

    // ── 3. WATCHES ────────────────────────────────────────────────────────
    MainCategory(
      id: 'watches',
      name: 'WATCHES',
      description:
          "Timeless and instantly identifiable, Cartier watches are distinguished by the essential nature of their design.",
      imageUrl:
          'https://images.unsplash.com/photo-1524592094714-0f0654e359fc?w=900&fit=crop&q=80',
      subCategories: [
        SubCategory(
          id: 'w_tank',
          name: 'Tank',
          products: _gen(
            prefix: 'w_tank',
            names: ['Tank Must', 'Tank Solo', 'Tank Américaine', 'Tank Louis Cartier', 'Tank Anglaise', 'Tank Française', 'Tank MC', 'Tank de Cartier', 'Tank Must SolarBeat', 'Tank Cintrée'],
            imgs: _imgWatch, basePrice: 3200, step: 900,
          ),
        ),
        SubCategory(
          id: 'w_santos',
          name: 'Santos de Cartier',
          products: _gen(
            prefix: 'w_santos',
            names: ['Santos de Cartier Large', 'Santos de Cartier Medium', 'Santos 100', 'Santos Dumont', 'Santos-Dumont XL', 'Santos Skeleton', 'Santos de Cartier Pavé', 'Santos WSSA0029', 'Santos Chronograph', 'Santos Ronde'],
            imgs: _imgWatch, basePrice: 6800, step: 1200,
          ),
        ),
        SubCategory(
          id: 'w_ballon',
          name: 'Ballon de Cartier',
          products: _gen(
            prefix: 'w_ballon',
            names: ['Ballon Bleu 33mm', 'Ballon Bleu 36mm', 'Ballon Bleu 40mm', 'Ballon Bleu 42mm', 'Ballon Bleu Pavé', 'Ballon Bleu Rose Gold', 'Ballon Bleu Two-Tone', 'Ballon Bleu Steel', 'Ballon Bleu Diamond', 'Ballon Blanc'],
            imgs: _imgWatch, basePrice: 5500, step: 1100,
          ),
        ),
        SubCategory(
          id: 'w_panthere',
          name: 'Panthère de Cartier',
          products: _gen(
            prefix: 'w_panthere',
            names: ['Panthère de Cartier 27mm', 'Panthère de Cartier 35mm', 'Panthère Jewelry Watch', 'Panthère Quartz Steel', 'Panthère Yellow Gold', 'Panthère Two-Tone', 'Panthère Diamond', 'Panthère Pavé', 'Panthère Mini', 'Panthère Manchette'],
            imgs: _imgWatch, basePrice: 4500, step: 2000,
          ),
        ),
        SubCategory(
          id: 'w_baignoire',
          name: 'Baignoire',
          products: _gen(
            prefix: 'w_baignoire',
            names: ['Baignoire Small', 'Baignoire Large', 'Baignoire Allongée', 'Baignoire 1920', 'Baignoire Gold', 'Baignoire Diamond', 'Baignoire Two-Tone', 'Baignoire Steel', 'Baignoire Pavé', 'Baignoire Automatique'],
            imgs: _imgWatch, basePrice: 7500, step: 2500,
          ),
        ),
        SubCategory(
          id: 'w_fine',
          name: 'Fine Watchmaking',
          products: _gen(
            prefix: 'w_fine',
            names: ['Rotonde de Cartier Skeleton', 'Clé de Cartier Automatic', 'Drive de Cartier', 'Astromystérieux', 'Rotonde Perpetual Calendar', 'Santos 100 Carbon', 'Calibre de Cartier', 'Rotonde Astrotourbillon', 'Masse Mystérieuse', 'ID Two Concept'],
            imgs: _imgWatch, basePrice: 18000, step: 5000,
          ),
        ),
        SubCategory(
          id: 'w_mini',
          name: 'Mini Watches',
          products: _gen(
            prefix: 'w_mini',
            names: ['Mini Baignoire', 'Mini Panthère', 'Mini Tank', 'Tortue XS', 'Cloche de Cartier', 'Mini Ronde', 'Pasha Mini', 'Crash Mini', 'Coussin Mini', 'Mini Ballon'],
            imgs: _imgWatch, basePrice: 3800, step: 900,
          ),
        ),
        SubCategory(
          id: 'w_strap',
          name: 'By Bracelet or Strap',
          products: _gen(
            prefix: 'w_strap',
            names: ['Steel Bracelet Watch', 'Leather Strap Watch', 'Alligator Strap Watch', 'Fabric Strap Watch', 'Gold Bracelet Watch', 'Two-Tone Bracelet', 'NATO Strap Watch', 'Rubber Strap Watch', 'Satin Strap Watch', 'Perlon Strap Watch'],
            imgs: _imgWatch, basePrice: 4200, step: 800,
          ),
        ),
        SubCategory(
          id: 'w_material',
          name: 'By Material',
          products: _gen(
            prefix: 'w_material',
            names: ['Yellow Gold Watch', 'Rose Gold Watch', 'White Gold Watch', 'Stainless Steel Watch', 'Titanium Watch', 'Carbon Watch', 'Diamond-Set Watch', 'Two-Tone Gold', 'Platinum Watch', 'Ceramic Watch'],
            imgs: _imgWatch, basePrice: 5000, step: 3000,
          ),
        ),
      ],
    ),

    // ── 4. BAGS & ACCESSORIES ─────────────────────────────────────────────
    MainCategory(
      id: 'bags',
      name: 'BAGS & ACCESSORIES',
      description:
          "Timeless elegance meets modern design across iconic collections including Panthère, C de Cartier, and Must de Cartier.",
      imageUrl:
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=900&fit=crop&q=80',
      subCategories: [
        SubCategory(
          id: 'b_womens',
          name: "Women's Bags",
          products: _gen(
            prefix: 'b_womens',
            names: ['Tote Bag C de Cartier', 'Shoulder Bag Panthère', 'Mini Bag Trinity', 'Evening Bag Panthère', 'Top Handle C de Cartier', 'Crossbody Panthère', 'Clutch Must de Cartier', 'Bucket Bag Trinity', 'Belt Bag C de Cartier', 'Mini Tote Panthère'],
            imgs: _imgBag, basePrice: 2200, step: 600,
          ),
        ),
        SubCategory(
          id: 'b_mens',
          name: "Men's Bags",
          products: _gen(
            prefix: 'b_mens',
            names: ['Business Bag Santos', 'Lifestyle Bag C de Cartier', 'Tote Bag Must de Cartier', 'Messenger Bag Cartier', 'Backpack Santos', 'Document Case', 'Weekend Bag', 'Laptop Bag Cartier', 'Clutch Santos', 'Travel Bag Cartier'],
            imgs: _imgBag, basePrice: 1800, step: 500,
          ),
        ),
        SubCategory(
          id: 'b_leather',
          name: 'Small Leather Goods',
          products: _gen(
            prefix: 'b_leather',
            names: ['Love Card Holder', 'Trinity Wallet', 'Panthère Key Case', 'Must de Cartier Purse', 'C de Cartier Card Case', 'LOVE Compact Wallet', 'Santos Cardholder', 'Panthère Coin Purse', 'Cartier Key Ring Wallet', 'Trinity Key Holder'],
            imgs: _imgBag, basePrice: 380, step: 120,
          ),
        ),
        SubCategory(
          id: 'b_accessories',
          name: 'Accessories',
          products: _gen(
            prefix: 'b_accessories',
            names: ['Panthère Cufflinks', 'Santos Cufflinks', 'Cartier Silk Scarf', 'LOVE Belt', 'Panthère Belt', 'Cartier Key Ring', 'Must de Cartier Lighter', 'Travel Wallet', 'Luggage Tag', 'Cartier Hat'],
            imgs: _imgBag, basePrice: 250, step: 150,
          ),
        ),
        SubCategory(
          id: 'b_sunglasses',
          name: 'Sunglasses',
          products: _gen(
            prefix: 'b_sunglasses',
            names: ['Panthère de Cartier Sunglasses', 'Santos de Cartier Sunglasses', 'Décor C de Cartier', 'Clash de Cartier Sunglasses', 'Signature C Sunglasses', 'Première de Cartier', 'C de Cartier Aviator', 'Cartier Rimless', 'Santos Pilot Sunglasses', 'Must Sunglasses'],
            imgs: _imgBag, basePrice: 680, step: 120,
          ),
        ),
      ],
    ),

    // ── 5. FRAGRANCES ─────────────────────────────────────────────────────
    MainCategory(
      id: 'fragrances',
      name: 'FRAGRANCES',
      description:
          "An olfactory journey through the Maison's heritage — each Cartier fragrance an intimate signature of exceptional savoir-faire.",
      imageUrl:
          'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=900&fit=crop&q=80',
      subCategories: [
        SubCategory(
          id: 'f_all',
          name: 'All Fragrances',
          products: _gen(
            prefix: 'f_all',
            names: ['La Panthère', 'Pasha de Cartier', 'Baiser Volé', 'Déclaration', 'Carat', 'Oud & Oud', "L'Heure Promise", 'Délices de Cartier', 'Roadster', 'So Pretty de Cartier'],
            imgs: _imgFrag, basePrice: 85, step: 30,
          ),
        ),
        SubCategory(
          id: 'f_high',
          name: 'High Perfumery',
          products: _gen(
            prefix: 'f_high',
            names: ["L'Heure Défendue", "L'Heure Brillante", "L'Heure Mystérieuse", "L'Heure Convoitée", "L'Heure Folle", 'Les Heures de Parfum', "L'Heure Diaphane", "L'Heure Audacieuse", "L'Heure Fougueuse", 'Voyage en Neroli'],
            imgs: _imgFrag, basePrice: 220, step: 45,
          ),
        ),
        SubCategory(
          id: 'f_sets',
          name: 'Sets',
          products: _gen(
            prefix: 'f_sets',
            names: ['La Panthère Gift Set', 'Pasha Gift Set', 'Baiser Volé Discovery Set', 'Déclaration Gift Set', 'Carat Duo Set', 'Les Heures Set', 'Holiday Fragrance Set', 'Discovery Collection', 'Eau de Toilette Set', 'Travel Gift Set'],
            imgs: _imgFrag, basePrice: 120, step: 25,
          ),
        ),
        SubCategory(
          id: 'f_home',
          name: 'Scented Home',
          products: _gen(
            prefix: 'f_home',
            names: ['Les Écrins Parfumés Candle', 'Cartier Home Diffuser', 'La Panthère Room Spray', 'Cartier Scented Sachet', 'Home Fragrance Set', 'Écrins Parfumés Duo', 'Luxury Candle Cartier', 'Reed Diffuser Cartier', 'Scented Pillow Mist', 'Cartier Home Collection'],
            imgs: _imgFrag, basePrice: 95, step: 35,
          ),
        ),
        SubCategory(
          id: 'f_choose',
          name: 'Choose Your Fragrance',
          products: _gen(
            prefix: 'f_choose',
            names: ['For Her — La Panthère', 'For Him — Pasha', 'For Her — Baiser Volé', 'For Him — Déclaration', 'Unisex — Oud & Oud', 'For Her — Carat', 'For Him — Roadster', 'Gift for Her', 'Gift for Him', 'The Signature Edit'],
            imgs: _imgFrag, basePrice: 90, step: 20,
          ),
        ),
      ],
    ),

    // ── 6. HOME & STATIONERY ──────────────────────────────────────────────
    MainCategory(
      id: 'home_stationery',
      name: 'HOME & STATIONERY',
      description:
          "Elevate your everyday moments with refined home essentials and exquisite writing instruments.",
      imageUrl:
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=900&fit=crop&q=80',
      subCategories: [
        SubCategory(
          id: 'hs_pens',
          name: 'Pens & Stationery',
          products: _gen(
            prefix: 'hs_pens',
            names: ['Santos de Cartier Ballpoint', 'Santos de Cartier Rollerball', 'Santos de Cartier Fountain Pen', 'Must de Cartier Ballpoint', 'Diabolo de Cartier Pen', 'Cartier Leather Notebook', 'Santos Note Pad', 'Cartier Agenda', 'Must Rollerball', 'Panthère Pen'],
            imgs: _imgHome, basePrice: 195, step: 85,
          ),
        ),
        SubCategory(
          id: 'hs_home',
          name: 'Home',
          products: _gen(
            prefix: 'hs_home',
            names: ['Cartier Characters Ashtray', 'Panthère Vase', 'Diabolo de Cartier Box', 'Baby Gift Set', 'Cartier Jewellery Box', 'Panthère Picture Frame', 'Cartier Porcelain Cup', 'Cartier Trinket Tray', 'Geometric Jewellery Box', 'Cartier Silk Cushion'],
            imgs: _imgHome, basePrice: 350, step: 150,
          ),
        ),
      ],
    ),
  ];
}
