# Web Menu Styles

These are example styles we could recommend for common styling of web menus

## Menu with thumbnail images on the left (kinda like Untappd)

```css
<style type="text/css">
  .evergreen-menu-item {
    display: flex;
    flex-direction: row-reverse;
    justify-content: flex-end;
    align-items: center;
  }
  .evergreen-menu-item-image {
    width: 100px;
    height: 100px;
  }
</style>
```

## Classy, three column dinner menu

```css
<style type="text/css">
  .evergreen-menus {
    margin-top: 25px;
  }
  .evergreen-menus ul {
    -webkit-columns: 290px 3;
    -moz-columns: 290px 3;
    columns: 290px 3;
  }
  .evergreen-menus li {
    -webkit-column-break-inside: avoid;
    page-break-inside: avoid;
    break-inside: avoid;
  }
  .evergreen-menu-item {
    margin-bottom: 1rem;
  }
  .evergreen-menu-title, .evergreen-menu-item-price {
    color: #954900;
  }
  .evergreen-menu-item-image img {
    max-width: 200px;
    max-height: 200px;
  }
  .evergreen-menu-item-price {
    float: right;
  }
</style>
```
