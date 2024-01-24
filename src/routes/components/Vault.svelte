<script lang="ts">
    import { onMount } from 'svelte';
    import { web3, defaultEvmStores } from 'svelte-web3';
    import CAPYVaultABI from './contract/CapyVault.ABI.json'
  
    let isConnected = false;
    let capyVaultContract: any;
    let accountBalance: string = '';

    const contractAddress = '0xYourContractAddress'; // Replace with your contract address

    onMount(async () => {
        try {
            await defaultEvmStores.setProvider();
            isConnected = defaultEvmStores.selectedAccount !== null;

            if (isConnected) {
                // Initialize the contract
                const web3Instance: any = web3; // Type assertion
                capyVaultContract = new web3Instance.eth.Contract(CAPYVaultABI, contractAddress);

                // Fetch and display account balance
                updateAccountBalance();
            }
        } catch (error) {
            console.error("Error connecting to Web3:", error);
        }
    });

    const updateAccountBalance = async () => {
        if (capyVaultContract && defaultEvmStores.selectedAccount) {
            try {
                const web3Instance: any = web3; // Type assertion
                const balance = await capyVaultContract.methods.balanceOf(defaultEvmStores.selectedAccount).call();
                accountBalance = web3Instance.utils.fromWei(balance, 'ether') + ' ETH';
            } catch (error) {
                console.error("Error fetching account balance:", error);
            }
        }
    };
</script>

{#if isConnected}
    <p>Account Balance: {accountBalance}</p>
{:else}
    <p>Please connect your wallet.</p>
{/if}
