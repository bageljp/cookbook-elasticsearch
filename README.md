What's ?
===============
chef で使用する ElasticSearch の cookbook です。

Usage
-----
cookbook なので berkshelf で取ってきて使いましょう。

* Berksfile
```ruby
source "https://supermarket.chef.io"

cookbook "elasticsearch", git: "https://github.com/bageljp/cookbook-elasticsearch.git"
```

```
berks vendor
```

#### Role and Environment attributes

* sample_role.rb
```ruby
override_attributes(
  "elasticsearch" => {
    "es_heap_size" => "1g"
  }
)
```

Recipes
----------

#### elasticsearch::default
ElasticSearch のインストールと設定。

Attributes
----------

主要なやつのみ。

#### elasticsearch::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><tt>['elasticsearch']['es_heap_size']</tt></td>
    <td>string</td>
    <td>ElasticSearch に割り当てるJVMヒープサイズ。</td>
  </tr>
</table>

