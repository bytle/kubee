import {visit} from "unist-util-visit";
import type {Root} from 'hast'

/**
 * The pattern to search in href
 */
const publicPattern = '/public/';

/**
 * Astro path does not have the md or mdx extension but the link checker needs them
 * This plugin will delete the markdown extension from a link
 *
 * Example:
 * * /docs/getting-started.md → /docs/getting-started
 * * /docs/getting-started.mdx → /docs/getting-started
 * * /docs/index.md → /docs
 * * /docs/index.mdx → /docs
 * * Leaves external links untouched
 *
 * Remove also the public
 * * ../../../public/static/file.pdf -> /static/file.pdf
 *
 * @returns {(function(*): void)|*}
 */
export default function rehypeHrefRewrite() {
    return (tree: Root) => {
        visit(tree, "element", (node) => {
            if (
                !(
                    node.tagName === "a" &&
                    node.properties &&
                    typeof node.properties.href === "string"
                )
            ) {
                return;
            }

            const href = node.properties.href;

            // Skip external, hash, and mailto links
            if (
                href.startsWith("http://") ||
                href.startsWith("https://") ||
                href.startsWith("#") ||
                href.startsWith("mailto:")
            ) {
                return;
            }

            /**
             * Special case so that the href is not empty
             * by the replacement below
             */
            if (href === "index.md" || href === "index.mdx") {
                node.properties.href = ".";
                return
            }

            // Remove .md or .mdx at the end (before optional slash)
            node.properties.href = href.replace(/(\.mdx?|\/index\.mdx?)$/, "");

            // Remove the public part
            // ie
            const publicIndex = node.properties.href.indexOf(publicPattern)
            if (publicIndex == -1) {
                return;
            }
            node.properties.href = node.properties.href.slice(publicIndex + publicPattern.length)

        });
    };
}
