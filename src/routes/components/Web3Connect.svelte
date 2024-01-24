<script lang="ts">
    import { onMount } from 'svelte';
    import { defaultEvmStores as evm, selectedAccount, chainId, web3 } from 'svelte-web3';

    let isConnected: boolean = false;
    let isCorrectBlockchain: boolean = false;
    const targetBlockchainId: number = 168587773; // Assuming blockchain ID can be represented as a number
    let accountBalance: string = '';

    $: isCorrectBlockchain = Number($chainId) === targetBlockchainId;
    $: if (isConnected && isCorrectBlockchain) {
        updateAccountBalance();
    }

    onMount(async () => {
        try {
            await evm.setProvider();
            isConnected = selectedAccount !== null;
        } catch (error) {
            console.error("Erreur de connexion Web3 :", error);
        }
    });

    const updateAccountBalance = async (): Promise<void> => {
        if ($web3.utils.isAddress($selectedAccount)) {
            const balance = await $web3.eth.getBalance($selectedAccount);
            accountBalance = $web3.utils.fromWei(balance, 'ether') + ' ETH'; // Displayed in ETH
        }
    };
</script>

{#if !isCorrectBlockchain}
    <div class="alert">
        <p> You are not connected to the correct blockchain.</p><p> Please change blockchain to use this application. </p>
    </div>
{/if}

<div class="wallet-connect">
    {#if isConnected}
        <p>Account Balance: {accountBalance}</p>
    {:else}
        <button on:click="{evm.setProvider}" class="button">Connect to Wallet</button>
    {/if}
</div>
