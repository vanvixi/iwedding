#!/bin/bash

# Script to deploy Firestore rules and indexes
# Run: ./deploy_firestore.sh

echo "🔥 Deploying Firestore Rules and Indexes..."
echo ""

# Check Firebase CLI
if ! command -v firebase &> /dev/null
then
    echo "❌ Firebase CLI is not installed"
    echo "Install it: npm install -g firebase-tools"
    exit 1
fi

# Deploy Firestore rules
echo "📋 Deploying Firestore Security Rules..."
firebase deploy --only firestore:rules

if [ $? -eq 0 ]; then
    echo "✅ Firestore rules deployed successfully"
else
    echo "❌ Error deploying Firestore rules"
    exit 1
fi

echo ""

# Deploy Firestore indexes
echo "📊 Deploying Firestore Indexes..."
firebase deploy --only firestore:indexes

if [ $? -eq 0 ]; then
    echo "✅ Firestore indexes deployed successfully"
else
    echo "❌ Error deploying Firestore indexes"
    exit 1
fi

echo ""
echo "🎉 Deploy completed!"
