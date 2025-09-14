// GeoSciML Enhanced Navigation
document.addEventListener('DOMContentLoaded', function() {
    
    // Add smooth scrolling for internal links
    const links = document.querySelectorAll('a[href^="#"]');
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Highlight current section in sidebar
    function highlightCurrentSection() {
        const sections = document.querySelectorAll('h1, h2, h3');
        const tocLinks = document.querySelectorAll('#TOC a, .toc a');
        
        let currentSection = null;
        const scrollPos = window.scrollY + 100;

        sections.forEach(section => {
            if (section.offsetTop <= scrollPos) {
                currentSection = section;
            }
        });

        // Remove all active classes
        tocLinks.forEach(link => link.classList.remove('active'));

        // Add active class to current section
        if (currentSection) {
            const currentId = currentSection.id;
            if (currentId) {
                const currentLink = document.querySelector(`#TOC a[href="#${currentId}"], .toc a[href="#${currentId}"]`);
                if (currentLink) {
                    currentLink.classList.add('active');
                }
            }
        }
    }

    // Add scroll listener for active section highlighting
    window.addEventListener('scroll', highlightCurrentSection);
    
    // Initial call to highlight current section
    highlightCurrentSection();

    // Add mobile toggle for sidebar
    const sidebar = document.querySelector('#TOC, .toc, nav#TOC');
    if (sidebar) {
        // Create mobile toggle button
        const toggleButton = document.createElement('button');
        toggleButton.innerHTML = '☰ Table of Contents';
        toggleButton.className = 'mobile-toc-toggle';
        toggleButton.style.cssText = `
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            z-index: 1000;
            background: var(--secondary-color, #3498db);
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        `;

        // Add mobile styles
        const mobileStyles = document.createElement('style');
        mobileStyles.textContent = `
            @media (max-width: 768px) {
                .mobile-toc-toggle {
                    display: block !important;
                }
                
                #TOC, .toc, nav#TOC {
                    position: fixed;
                    top: 0;
                    left: -280px;
                    height: 100vh;
                    z-index: 999;
                    transition: left 0.3s ease;
                    background: white;
                    box-shadow: 2px 0 10px rgba(0,0,0,0.3);
                }
                
                #TOC.mobile-open, .toc.mobile-open, nav#TOC.mobile-open {
                    left: 0;
                }
                
                .mobile-overlay {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0,0,0,0.5);
                    z-index: 998;
                    display: none;
                }
                
                .mobile-overlay.active {
                    display: block;
                }
            }
        `;
        document.head.appendChild(mobileStyles);

        // Create overlay for mobile
        const overlay = document.createElement('div');
        overlay.className = 'mobile-overlay';
        document.body.appendChild(overlay);

        // Toggle functionality
        toggleButton.addEventListener('click', function() {
            sidebar.classList.toggle('mobile-open');
            overlay.classList.toggle('active');
        });

        overlay.addEventListener('click', function() {
            sidebar.classList.remove('mobile-open');
            overlay.classList.remove('active');
        });

        // Insert toggle button
        document.body.insertBefore(toggleButton, document.body.firstChild);
    }

    // Add copy button to code blocks
    const codeBlocks = document.querySelectorAll('pre code');
    codeBlocks.forEach(codeBlock => {
        const pre = codeBlock.parentElement;
        const copyButton = document.createElement('button');
        copyButton.className = 'copy-code-btn';
        copyButton.innerHTML = '📋 Copy';
        copyButton.style.cssText = `
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255,255,255,0.8);
            border: 1px solid #ddd;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
            font-size: 12px;
            opacity: 0;
            transition: opacity 0.3s ease;
        `;

        pre.style.position = 'relative';
        pre.appendChild(copyButton);

        pre.addEventListener('mouseenter', () => {
            copyButton.style.opacity = '1';
        });

        pre.addEventListener('mouseleave', () => {
            copyButton.style.opacity = '0';
        });

        copyButton.addEventListener('click', () => {
            navigator.clipboard.writeText(codeBlock.textContent).then(() => {
                copyButton.innerHTML = '✅ Copied!';
                setTimeout(() => {
                    copyButton.innerHTML = '📋 Copy';
                }, 2000);
            });
        });
    });

    console.log('GeoSciML enhanced navigation loaded successfully!');
});
