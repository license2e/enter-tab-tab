ETT.ns 'models.migrate'
ETT.models.migrate = 
  init: () ->
    if ETT.settings.db.sample_deleted == false and ETT.settings.db.sample_created == false
      # create sample project
      proj = ETT.models.projects.create key:'sample', name:'EnterTabTab'
      
      # add copydeck to project
      copy = proj.add_copydeck key:'sample', name:'Landing Page v0.1'
      
      # try add copydeck categories
      try
        site_page_key     = copy.add_category key:'site-page',      category:'site-page',       name: 'Site Page'
        site_section_key  = copy.add_category key:'site-section',   category:'site-section',    name: 'Site Section'
        page_title_key    = copy.add_category key:'page-title',     category:'page-title',      name: 'Page Title'
        header1_key       = copy.add_category key:'header1',        category:'header1',         name: 'Page Header'
        header2_key       = copy.add_category key:'header2',        category:'header2',         name: 'Page Subheader'
        header3_key       = copy.add_category key:'header3',        category:'header3',         name: 'Section Header'
        body_content_key  = copy.add_category key:'body-content',   category:'body-content',    name: 'Body Content'
        cta_key           = copy.add_category key:'cta',            category:'cta',             name: 'Call To Action'
        list_header_key   = copy.add_category key:'list-header',    category:'list-header',     name: 'List Header'
        list_item_key     = copy.add_category key:'list-item',      category:'list-item',       name: 'List Item'
        copyright_key     = copy.add_category key:'copyright',      category:'copyright',       name: 'Copyright'
      catch e
        console.log e.stack
        throw 'app-migrate:: lines: 13 - 22 -- message:' + e.message
      
      # try add entries to the copydeck
      try
        copy.add_entry key:'site_page_1',     category:site_page_key,      value: 'single landing page'
        copy.add_entry key:'site_section_1',  category:site_section_key,   value: 'home page'
        copy.add_entry key:'page_title_1',    category:page_title_key,     value: 'Simple. Focused. Content | EnterTabTab'
        copy.add_entry key:'header1_1',       category:header1_key,        value: 'Simple. Focused. Content'
        copy.add_entry key:'header2_1',       category:header2_key,        value: 'Writing content just got easier'
        copy.add_entry key:'cta_1',           category:cta_key,            value: '[button] Download Now!'
        copy.add_entry key:'header3_1',       category:header3_key,        value: 'Features'
        copy.add_entry key:'list_header_1',   category:list_header_key,    value: 'Format-free writing'
        copy.add_entry key:'list_item_1_1',   category:list_item_key,      value: 'Stop worrying about perfect format while writing'
        copy.add_entry key:'list_item_1_2',   category:list_item_key,      value: 'Write in full-screen without distractions'
        copy.add_entry key:'list_item_1_3',   category:list_item_key,      value: 'Easy navigation using just the Tab and Enter keys'
        copy.add_entry key:'list_header_2',   category:list_header_key,    value: 'Built-in collaboration and workflow'
        copy.add_entry key:'list_item_2_1',   category:list_item_key,      value: 'Collaborate with co-workers and colleagues'
        copy.add_entry key:'list_item_2_2',   category:list_item_key,      value: 'Flexible environment for cross-disciplines teams'
        copy.add_entry key:'list_item_2_3',   category:list_item_key,      value: 'Approval workflow for Risk, Security and Compliance'
        copy.add_entry key:'list_header_3',   category:list_header_key,    value: 'Easy post-digest options'
        copy.add_entry key:'list_item_3_1',   category:list_item_key,      value: 'Multiple formats available for any business department'
        copy.add_entry key:'list_item_3_2',   category:list_item_key,      value: 'Export into Word, Excel, PDF, Text, JSON, XML, Markdown formats'
        copy.add_entry key:'list_item_3_3',   category:list_item_key,      value: 'API for direct usage or existing system integration'
        copy.add_entry key:'cta_2',           category:cta_key,            value: '[button] Download Now!'
        copy.add_entry key:'copyright_1',     category:copyright_key,      value: 'Copyright {2013} EON Media Group. All rights reserved.'
      catch e  
        console.log e.stack
        throw 'app-migrate:: lines: 28 - 49 -- message:' + e.message
        
      # update the settings for sample
      ETT.settings.db_model.set_value 'sample_created', true
    true