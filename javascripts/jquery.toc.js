/*
 * jQuery Table of Content Generator for Markdown v1.0
 *
 * https://github.com/dafi/tocmd-generator
 * Examples and documentation at: https://github.com/dafi/tocmd-generator
 *
 * Requires: jQuery v1.7+
 *
 * Copyright (c) 2013 Davide Ficano
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 * 
 * Edited by Carsten Haubold @ IWR to fit the needs of the ilastik website
 */
(function($) {
    function createLevelHTML(anchorId, tocLevel, tocSection, tocText, tocInner) {
        var link = '<a href="#%1"> <span class="toctext">%3</span></a>%4'
            .replace('%1', anchorId)
            .replace('%3', tocText)
            .replace('%4', tocInner ? tocInner : '');
        return '<li class="toclevel-%1 tocsection-%2">%3</li>\n'
            .replace('%1', tocLevel)
            .replace('%2', tocSection)
            .replace('%3', link);
    }

    $.fn.toc = function(settings) {
        var config = {
            renderIn: 'self',
            anchorPrefix: 'tocAnchor-'};

        if (settings) {
            $.extend(config, settings);
        }

        var tocHTML = '';
        var tocLevel = 1;
        var tocSection = 1;

        var tocContainer = $(this);

        tocContainer.find('h1').each(function() {
            var levelHTML = '';
            var innerSection = 0;
            var h1 = $(this);

            h1.nextUntil('h1').filter('h2').each(function() {
                ++innerSection;
                var anchorId = config.anchorPrefix + tocLevel + '-' + tocSection + '-' +  + innerSection;
                $(this).attr('id', anchorId);
                levelHTML += createLevelHTML(anchorId,
                    tocLevel + 1,
                    tocSection + innerSection,
                    $(this).text());
            });
            if (levelHTML) {
                levelHTML = '<ul>' + levelHTML + '</ul>\n';
            }
            var anchorId = config.anchorPrefix + tocLevel + '-' + tocSection;
            h1.attr('id', anchorId);
            if(tocSection == 1) {
                tocHTML += levelHTML
            }
            else {
                tocHTML += createLevelHTML(anchorId,
                    tocLevel,
                    tocSection,
                    h1.text(),
                    levelHTML);
            }

            tocSection += 1 + innerSection;
        });

        if (tocHTML) {
            // Renders in default or specificed path
            if (config.renderIn != 'self') {
              $(config.renderIn).html(tocHTML);
            } else {
              tocContainer.prepend(tocHTML);
            }
        }
        return this;
    }
})(jQuery);