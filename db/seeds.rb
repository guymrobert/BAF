# Admin User
CHAIN_ID = Rails.env.development? ? 4 : 1
AdminUser.find_or_create_by(email: "ADMIN_EMAIL_HERE")
  .update(password: "ADMIN_PASSWORD_HERE", first_name: "ADMIN_FIRST_NAME_HERE", last_name: "ADMIN_LAST_NAME_HERE", password_confirmation: "ADMIN_PASSWORD_CONFIRMATION_HERE")

Fee.find_or_create_by(fee_type: 'service_charge')
  .update(name: 'Service Charge', percentage: '2.5')

["Art", "Animation", "Games", "Music", "Videos", "Memes", "Metaverses"].each { |c| Category.find_or_create_by(name: c) }

Erc20Token.find_or_create_by(chain_id: CHAIN_ID, symbol: 'WETH')
  .update(address: 'WETH_CONTRACT_ADDRESS_HERE', name: 'Wrapped Ether', decimals: 18)

NftContract.find_or_create_by(contract_type: 'nft721', symbol: 'Shared')
  .update(name: 'NFT', address: '721_CONTRACT_ADDRESS_HERE')
NftContract.find_or_create_by(contract_type: 'nft1155', symbol: 'Shared')
  .update(name: 'NFT', address: '1155_CONTRACT_ADDRESS_HERE')
