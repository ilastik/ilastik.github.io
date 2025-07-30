(function() {
  let idx = null;
  let documents = [];

  async function loadSearchIndex() {
    try {
      const response = await fetch('/search.json');
      documents = await response.json();

      idx = lunr(function () {
        this.ref('url');
        this.field('title');
        this.field('content');

        documents.forEach(doc => this.add(doc));
      });
    } catch (error) {
      console.error('Error loading search index:', error);
    }
  }

  function performSearch(query) {
    const resultsList = document.getElementById('search-results');
    if (!resultsList) return;

    resultsList.innerHTML = '';

    if (!idx || query.length < 2) {
      resultsList.style.display = 'none';
      return;
    }

    const results = idx.search(query);

    if (results.length === 0) {
      resultsList.innerHTML = '<li style="padding: 8px;">No results found</li>';
      resultsList.style.display = 'block';
      return;
    }

    results.slice(0, 10).forEach(result => {
      const doc = documents.find(d => d.url === result.ref);
      if (doc) {
        const li = document.createElement('li');
        li.innerHTML = `<a href="${doc.url}" style="display: block; padding: 8px; color: #333;">${doc.title} - ${doc.section}</a>`;
        resultsList.appendChild(li);
      }
    });

    resultsList.style.display = 'block';
  }

  document.addEventListener('DOMContentLoaded', () => {
    loadSearchIndex();

    const input = document.getElementById('search-box');
    if (input) {
      input.addEventListener('input', () => {
        const query = input.value.trim();
        performSearch(query);
      });
    }

    document.addEventListener('click', (e) => {
      const resultsList = document.getElementById('search-results');
      const input = document.getElementById('search-box');
      if (resultsList && input && !resultsList.contains(e.target) && e.target !== input) {
        resultsList.style.display = 'none';
      }
    });
  });
})();
