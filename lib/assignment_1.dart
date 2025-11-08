// Abstract class for accounts that earn interest
abstract class InterestBearing {
  double calculateInterest();
}

// Abstract base class for all bank accounts
abstract class BankAccount {
  // Private fields
  final int _accountNumber;
  final String _accountHolderName;
  double _balance;

  // Constructor
  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // Getters
  int get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;

  // Setter for balance
  set balance(double value) {
    _balance = value;
  }

  // Abstract methods 
  void deposit(double amount);
  void withdraw(double amount);

  // Method to show account information
  void displayAccountInfo() {
    print("Account Number: $_accountNumber");
    print("Account Holder: $_accountHolderName");
    print("Balance: $_balance");
  }
}

// Savings Account Class inherits BankAccount and earns interest
class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawalCount = 0; // Track withdrawals
  final double _interestRate = 0.02; // 2% interest
  final double _minimumBalance = 500.0; // Minimum balance

  SavingsAccount(super.accountNumber, super.accountHolderName, super.balance);

  // Add money
  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited $amount into Savings Account.");
  }

  // Withdraw money with limits
  @override
  void withdraw(double amount) {
    if (_withdrawalCount >= 3) {
      print("Withdrawal limit reached (3 times per month).");
    } else if (balance - amount < _minimumBalance) {
      print("Cannot withdraw! Minimum balance of $_minimumBalance required.");
    } else {
      balance -= amount;
      _withdrawalCount++;
      print("Withdrawn $amount from Savings Account.");
    }
  }

  // Calculate interest
  @override
  double calculateInterest() {
    return balance * _interestRate;
  }
}

// Checking Account Class inherits BankAccount
class CheckingAccount extends BankAccount {
  final double _overdraftFee = 35.0; // Fee if balance goes below 0

  CheckingAccount(super.accountNumber, super.accountHolderName, super.balance);

  // Add money
  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited $amount into Checking Account.");
  }

  // Withdraw money 
  @override
  void withdraw(double amount) {
    balance -= amount;
    if (balance < 0) {
      balance -= _overdraftFee;
      print("Overdraft! $_overdraftFee fee charged.");
    } else {
      print("Withdrawn $amount from Checking Account.");
    }
  }
}

// Premium Account Class inherits BankAccount and earns interest
class PremiumAccount extends BankAccount implements InterestBearing {
  final double _minimumBalance = 10000.0; // Minimum balance
  final double _interestRate = 0.05; // 5% interest

  PremiumAccount(super.accountNumber, super.accountHolderName, super.balance);

  // Add money
  @override
  void deposit(double amount) {
    balance += amount;
    print("Deposited $amount into Premium Account.");
  }

  // Withdraw money 
  @override
  void withdraw(double amount) {
    if (balance - amount < _minimumBalance) {
      print("Cannot withdraw! Minimum balance of $_minimumBalance required.");
    } else {
      balance -= amount;
      print("Withdrawn $amount from Premium Account.");
    }
  }

  // Calculate interest
  @override
  double calculateInterest() {
    return balance * _interestRate;
  }
}

// Bank Class 
class Bank {
  List<BankAccount> accounts = []; // List to store all accounts

  // Create a new account
  void createAccount(BankAccount account) {
    accounts.add(account);
    print("New account created for ${account.accountHolderName}");
  }

  // Find account by account number
  BankAccount? findAccount(int accountNumber) {
    for (var acc in accounts) {
      if (acc.accountNumber == accountNumber) {
        return acc;
      }
    }
    print("Account not found!");
    return null;
  }

  // Transfer money between two accounts
  void transfer(int fromAccNum, int toAccNum, double amount) {
    BankAccount? fromAcc = findAccount(fromAccNum);
    BankAccount? toAcc = findAccount(toAccNum);

    if (fromAcc == null || toAcc == null) {
      print("Transfer failed! One or both accounts not found.");
      return;
    }

    fromAcc.withdraw(amount);
    toAcc.deposit(amount);
    print("Transfer of $amount completed from ${fromAcc.accountHolderName} to ${toAcc.accountHolderName}");
  }

  // Show report of all accounts
  void generateReport() {
    print("|| BANK REPORT ||");
    for (var acc in accounts) {
      print("-----------------------------");
      acc.displayAccountInfo();
    }
  }
}

void main() {
  Bank bank = Bank(); // Create a bank object

  // Create 3 accounts
  var acc1 = SavingsAccount(11789, "Abhishek", 1000);
  var acc2 = CheckingAccount(2567, "Sanket", 500);
  var acc3 = PremiumAccount(9870, "Bhusan", 15000);

  // Add accounts to bank
  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);

  acc1.deposit(500);
  acc1.withdraw(200);
  print("Interest for Abhishek: ${acc1.calculateInterest()}");

  acc2.withdraw(600);
  acc2.deposit(200);

  acc3.withdraw(2000);
  print("Interest for Bhusan: ${acc3.calculateInterest()}");

  // Transfer money
  bank.transfer(11789, 2567, 1010);

  // Show report
  bank.generateReport();
}
