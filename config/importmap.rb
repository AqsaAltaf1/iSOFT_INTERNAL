# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin '@fortawesome/fontawesome-free', to: 'https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.1.1/js/fontawesome.js'
pin '@fortawesome/fontawesome-svg-core', to: 'https://ga.jspm.io/npm:@fortawesome/fontawesome-svg-core@6.1.1/index.es.js'
pin '@fortawesome/free-brands-svg-icons', to: 'https://ga.jspm.io/npm:@fortawesome/free-brands-svg-icons@6.1.1/index.es.js'
pin '@fortawesome/free-regular-svg-icons', to: 'https://ga.jspm.io/npm:@fortawesome/free-regular-svg-icons@6.1.1/index.es.js'
pin '@fortawesome/free-solid-svg-icons', to: 'https://ga.jspm.io/npm:@fortawesome/free-solid-svg-icons@6.1.1/index.es.js'
pin '@rails/actioncable', to: 'actioncable.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'
pin 'trix'
pin '@rails/actiontext', to: 'actiontext.js'
pin 'bootstrap', to: 'https://ga.jspm.io/npm:bootstrap@5.2.3/dist/js/bootstrap.esm.js'
pin '@popperjs/core', to: 'https://unpkg.com/@popperjs/core@2.11.6/dist/esm/index.js'
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.7.0/dist/jquery.js'
pin 'stimulus-character-counter', to: 'https://ga.jspm.io/npm:stimulus-character-counter@4.2.0/dist/stimulus-character-counter.mjs'
pin '@hotwired/stimulus', to: 'https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js'
pin 'datatables.net-dt', to: 'https://ga.jspm.io/npm:datatables.net-dt@1.13.3/js/dataTables.dataTables.mjs'
pin 'install', to: 'https://ga.jspm.io/npm:install@0.13.0/install.js'
pin 'datatables.net', to: 'https://ga.jspm.io/npm:datatables.net@1.13.3/js/jquery.dataTables.mjs'
