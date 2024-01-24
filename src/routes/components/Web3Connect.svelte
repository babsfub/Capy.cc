<script lang="ts">
    import { onMount } from 'svelte';
    import { defaultEvmStores as evm, selectedAccount, chainId, web3 } from 'svelte-web3';

    let isConnected: boolean = false;
    let isCorrectBlockchain: boolean = false;
    const targetBlockchainId: number = 168587773; 
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

    const formatBalance = (balance: string): string => {
        const parsedBalance = parseFloat(balance);
        return parsedBalance.toFixed(3); 
    };

    const updateAccountBalance = async (): Promise<void> => {
        if ($web3.utils.isAddress($selectedAccount)) {
            const balance = await $web3.eth.getBalance($selectedAccount);
            accountBalance = formatBalance($web3.utils.fromWei(balance, 'ether')) + ' ETH';
        }
    };
</script>


{#if !isCorrectBlockchain}
    <div class="alert">
        <p> Please change to Blast Testnet</p>
        <p> to use this application. </p>
    </div>
{/if}

<div class="wallet-connect">
    {#if isConnected}
        <div>
            <p>Balance:{accountBalance}</p>
        </div>
    {:else}
        <button on:click="{evm.setProvider}" class="button">Connect</button>
    {/if}
</div>
