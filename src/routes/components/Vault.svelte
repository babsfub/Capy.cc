<script lang="ts">
    import { onMount } from 'svelte';
    import { web3, defaultEvmStores } from 'svelte-web3';
    import CAPYVaultABI from './contract/CapyVault.ABI.json';

    let isConnected = false;
    let capyVaultContract: any;
    let accountBalance: string = '';
    const contractAddress = '0xYourContractAddress'; 

    onMount(async () => {
        try {
            await defaultEvmStores.setProvider();
            isConnected = defaultEvmStores.selectedAccount !== null;

            if (isConnected) {
                const web3Instance: any = web3; 
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

    // Example button action handlers
    async function buy() {
        if (!isConnected || !capyVaultContract) return;
        // Implement buy logic using capyVaultContract
    }

    async function hold() {
        if (!isConnected || !capyVaultContract) return;
        // Implement hold logic using capyVaultContract
    }

    async function holdAndLock() {
        if (!isConnected || !capyVaultContract) return;
        // Implement hold and lock logic using capyVaultContract
    }

    async function redeem() {
        if (!isConnected || !capyVaultContract) return;
        // Implement redeem logic using capyVaultContract
    }

    async function withdraw() {
        if (!isConnected || !capyVaultContract) return;
        // Implement withdraw logic using capyVaultContract
    }
</script>

{#if isConnected}
    
        <p>Account Balance: {accountBalance}</p>
        <div class="grid">
            <label for="buy">
                <input type="number" id="buy" placeholder="buy" required>
                    <button on:click={buy}>Buy</button>
                    <a href="#cancel" role="button" class="secondary">Cancel</a>
            </label>
            <label for="hold">
                <input type="number" id="Hold" placeholder="Hold" required>
                    <button on:click={hold}>Hold</button>
                    <a href="#cancel" role="button" class="secondary">Cancel</a>
            </label>
            <label for="Hold and Lock">
                <input type="number" id="HoldnLock" placeholder="Hold'n'Lock" required>
                    <button on:click={holdAndLock}>Hold'n'Lock</button>
                    <a href="#cancel" role="button" class="secondary">Cancel</a>
            </label>
            <label for="Redeem"> 
                <input type="number" id="Redeem" placeholder="Redeem" required>           
                    <button on:click={redeem}>Redeem</button>
                    <a href="#cancel" role="button" class="secondary">Cancel</a>
            </label>
            <label for="Withdraw">
                <input type="number" id="Withdraw" placeholder="Withdraw" required>
                    <button on:click={withdraw}>Withdraw</button>
                    <a href="#cancel" role="button" class="secondary">Cancel</a>
            </label>
            
        </div>
{:else}
    <p>Please connect your wallet.</p>
{/if}
