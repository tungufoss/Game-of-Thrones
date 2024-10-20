# Server logic for the 'Sources' tab

output$sources_info <- renderUI({
  HTML(
    "<p>This project is open source under Creative Commons.</p>
     <p>Sources for data and content include:</p>
     <ul>
       <li><i>Atlas Of Thrones: A Game of Thrones Interactive Map</i> by Patrick Triest
           [<a href='https://github.com/triestpa/Atlas-Of-Thrones' target='_blank'>Source</a>]</li>
       <li><i>An API of Ice And Fire</i> by Joakim Skoog
           [<a href='https://anapioficeandfire.com/' target='_blank'>Source</a>]</li>
     </ul>
     <p>For more details, visit the official
       <a href='https://github.com/tungufoss/Game-of-Thrones' target='_blank'>GitHub repository</a>.
     </p>"
  )
})
