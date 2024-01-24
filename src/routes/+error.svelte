<script>
    import Unclebara from './static/unclesam.png'; 
  </script>
  
  <style>
    .error-container {
      text-align: center;
      padding: 2rem;
    }
  
    .error-image {
      max-width: 300px;
      margin: 0 auto;
    }
  
    .error-message {
      font-size: 1.5rem;
      margin-top: 1rem;
    }
  </style>
  
  <div class="error-container">
    <img src={Unclebara} alt="Confused Capybara" class="error-image" />
    <p class="error-message">Oops! The page you're looking for seems to have wandered off.</p>
    <a href="/" class="button">Go back to the homepage</a>
  </div>
  