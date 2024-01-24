<!--Header.svelte-->
<script lang="ts">
  import { onMount } from 'svelte';
  import { ThemeSwitcher } from './minimal-theme-switcher';
  import Web3Connect from './components/Web3Connect.svelte';

  onMount(() => {
      ThemeSwitcher.init(); 
  });
</script>

<nav class="header">
  <ul>
    <li><a href="./" class="brand contrast"><strong>Capybara</strong></a></li>
  </ul>
  
  <ul>
    
    <!-- svelte-ignore a11y-invalid-attribute -->
    <li><ul>
      <details role="list" dir="rtl">
          <summary aria-haspopup="listbox" role="link" class="contrast">Theme</summary>
          <ul role="listbox" class="menu">
              <!-- svelte-ignore a11y-invalid-attribute -->
              <li><a href="#" data-theme-switcher="auto">Dark</a></li>
              <!-- svelte-ignore a11y-invalid-attribute -->
              <li><a href="#" data-theme-switcher="light">Light</a></li>
          </ul>  
        </details>    
            </ul></li>
            <li></li>
    <li><Web3Connect /></li>
  </ul>
</nav>
<style>
   .header {
    background-color: transparent;
    position: top;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 200;
  }
</style>