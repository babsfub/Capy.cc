
<script>
  import '@picocss/pico';
  import Header from './Header.svelte';
  import Unclebara from './static/unclesam.png';
</script>
<Header />

   
  <main class="main-background">
    <div class="container">
    <article>
      <div class="announcement">Be aware, the Capybara is coming!! Follow us on Twitter <a href="https://twitter.com/CapybaraCCoin">@CapybaraCCoin</a>
    </article>
   
    <article>
    <section class="intro">
      <h1>Welcome to Capybara™</h1>
      <p>Capybara™ is a decentralized brand built on the principles of decentralized finance (DeFi) and community governance. It facilitates an ecosystem where the community significantly influences the brand's decisions and developments.</p>
      
    </section>    
</article>

<article>
    <section class="key-aspects">
      <h2>Key Aspects of Capybara™</h2>
      <ul>
        <li>Decentralized Governance: A DAO-based governance system.</li>
        <li>Community-Driven: Decisions made collectively by the community.</li>
        <li>Project Funding: Community-voted funding allocation.</li>
        <li>Open Ecosystem: Inviting developers and innovators.</li>
        <li>Economic Incentives: Rewards for participation in governance and community activities.</li>
        <li>Transparency: Blockchain technology ensures transparent actions.</li>
      </ul>
    </section>
  </article>
  <div class="grid">
 

  <article>
    <section class="governance">
      <h2>Governance in Capybara™</h2>
      <p>Empowering users in decision-making through the Capybara DAO. Includes voting on key aspects like weekly cashout percentages and project funding.</p>
    
    </section>
  </article>
  
  <article>
    <section class="police">
      <h2>Ensuring Integrity: The Capybara Police</h2>
      <p>A dedicated group to monitor and enforce fairness within the ecosystem.</p>
      <!-- More information about the role and mechanism of the Police -->
    </section>
  </article>
</div>
<article>
  <section class="economy">
    <h2>Capybara Tokens</h2>
    <p>CAPY: A standard ERC-20 Contract. GARDEN: Locked CAPY-ETH LP with specific withdrawal and reward rules.</p>
   
  </section>
</article>
  <article>
    <section class="family">
      <h2>Family: Referral System in Capybara</h2>
      <p>A multi-level referral system rewarding users for expanding
  the community. This system incentivizes users to bring new participants into the Capybara ecosystem.</p>
  <!-- Elaborate more on the referral system, its tiers, and incentives -->
  
    </section>
    <section aria-label="Subscribe example">
      <div class="container">
          <article>
              <hgroup>
                  <h2>Subscribe</h2>
                  
              </hgroup>
              <form class="grid">
                  
              </form>
          </article>
      </div>
    </section>  
  </div>
  </main>
  <style>

.main-background {
  background-image: url('./static/unclesam.png'); 
  
  background-position: center;
  background-repeat: no-repeat; 
  background-attachment: fixed; 
}
    
    .container {
      max-width: 900px;
      margin: 0 auto;
      padding: 1em;
      opacity: 0.89;
    }
  
    .intro, .key-aspects, .economy, .governance, .police, .family {
      margin-bottom: 2em;
      
    }
  
    h1 {
      font-size: 2em;
      color: var(--color-primary);
    }
  
    h2 {
      font-size: 1.5em;
      color: var(--color-secondary);
    }
  
    ul {
      list-style-type: none;
      padding: 0;
    }
  
    
  </style>
 


