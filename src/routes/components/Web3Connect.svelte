<script>
    import { onMount } from 'svelte';
    import { defaultEvmStores as evm, selectedAccount, chainId, web3 } from 'svelte-web3';

    let isConnected = false;
    let isCorrectBlockchain = false;
    const targetBlockchainId = 168587773n; // Assurez-vous que c'est le bon ID de blockchain
    let accountBalance = '';

    $: isCorrectBlockchain = $chainId === targetBlockchainId;
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

    const updateAccountBalance = async () => {
        if ($web3.utils.isAddress($selectedAccount)) {
            const balance = await $web3.eth.getBalance($selectedAccount);
            accountBalance = $web3.utils.fromWei(balance).toString() + ' ETH'; // Changé pour afficher en ETH
        }
    };
</script>

{#if !isCorrectBlockchain}
    <div class="alert">
       <p> You are not connected to the correct blockchain.</p><p> Please change blockchain to use this application. </p></div>
{/if}

<div class="wallet-connect">
    {#if isConnected}
        <p>Account Balance: {accountBalance}</p>
    {:else}
        <button on:click="{evm.setProvider}" class="button-red margin-large padding-medium">Connect to Wallet</button>
    {/if}
</div>
