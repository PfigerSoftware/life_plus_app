class User {
  final int id;
  final String email;
  final String name;
  final String? mobile;
  final int? productId;
  final bool? isMobileVerified;
  final bool? isActive;
  final String? role;
  final String? lpcId;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.mobile,
    this.productId,
    this.isMobileVerified,
    this.isActive,
    this.role,
    this.lpcId
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'] ?? json['username'], // Fallback to username if name not provided
      mobile: json['mobile'],
      isActive: json['is_active'],
      isMobileVerified: json['is_mobile_verified'],
      productId: json['product_id'],
      role: json['role'],
      lpcId: json['lpc_id']
    );
  }
}

class Category {
  final int id;
  final String name;
  final String type; // 'income' or 'expense'
  final String? icon;
  final String? color;

  Category({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      icon: json['icon'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'icon': icon,
      'color': color,
    };
  }
}

class Transaction {
  final int id;
  final double amount;
  final DateTime date;
  final String? note;
  final Category category;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    this.note,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      date: DateTime.parse(json['date']),
      note: json['note'],
      category: Category.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
      'categoryId': category.id,
    };
  }
}

class Stats {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<Transaction> recentTransactions;

  Stats({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.recentTransactions,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      totalIncome: double.parse(json['totalIncome'].toString()),
      totalExpense: double.parse(json['totalExpense'].toString()),
      balance: double.parse(json['balance'].toString()),
      recentTransactions: (json['recentTransactions'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList(),
    );
  }
}
