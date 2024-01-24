<script lang="ts">
    import Header from "../Header.svelte";
    import Vault from "../components/Vault.svelte";
    import CWallet from "../components/CWallet.svelte";
    import Ad from "../components/Ad.svelte";
</script>

<Header />

<main class="main-background">
    <div class="container">
        <article>
            <Vault />
            <CWallet />
        </article>
    </div>
    <div>
   
        <section>
          <div class="container">
            <Ad />
          </div>
        </section>
      
    </div>
</main>
<style>
    .container {
      max-width: 970px;
      margin: 0 auto;
      padding: 1em;
      opacity: 0.89;
    }
</style>