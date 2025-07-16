// lib/features/wallet/presentation/pages/wallet_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => context.go('/home'), // CHANGED: Navigates back to home
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet,
                size: screenWidth * 0.2,
                color: Colors.blueGrey,
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                'My Wallets',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'View and manage your different financial accounts here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildWalletTile(context, 'Main Account', '\$12,345.67'),
                    _buildWalletTile(context, 'Savings Account', '\$5,000.00'),
                    _buildWalletTile(context, 'Credit Card', '-\$750.25'),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton.icon(
                onPressed: () {
                  // Action to add a new wallet
                  print('Add new wallet');
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Add New Wallet',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E90FF),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletTile(BuildContext context, String name, String balance) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Icon(Icons.account_balance, color: Colors.blue, size: screenWidth * 0.06),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        balance,
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
          color: balance.startsWith('-') ? Colors.redAccent : Colors.green,
        ),
      ),
      onTap: () {
        
        print('View details for $name');
      },
    );
  }
}