
## Programlama Dil Desteği

Milis Linux farklı programlama dilleri için pratik ve güncel bir çalışma ortamı sunmaktadır.
Aşağıda adı geçen programlama dillerinin kurulum bilgileri yer almaktadır.

#### C ve C++
- GCC derleyicisi kurulu gelmektedir.
- LLVM derleyicisi için `llvm`, `clang` paketleri kurulabilir.

#### Python
- Python 3.x sürümü kurulu gelmektedir.
- Python paket yöneticisi `pip` kurulu gelmektedir.

#### Lua
- Tercihe göre `lua` ve `luajit` paketleri kurulur.
- Statik olarak kurulu gelen `slua` ikilisi kullanılabilir. 

#### Java
- `sudo sdk_setup.sh` ile `sdk` aracı kurulur.
- sdk aracı ile `java` ve bileşenleri kurulabilir [(belge)](https://gitlab.com/milislinux/milis23/-/blob/main/belge/java.md).

#### D
- `dmd` paketi kurulur.
- dmd paketi dmd derleyicisi, phobos kütüphanesi ve dub paket yöneticisi ile gelmektedir.

#### Go
- `go_setup.sh $GO-SÜRÜM` ile istenen sürüm kurulumu yapılır.
- `$HOME/.local/go` altına kurulur.

#### Rust
- `rust.sh` ile son güncel sürüm kurulumu yapılır.
- `$HOME/.cargo` altına kurulur.

#### Ruby
- `ruby` (3.x) paketi kurulur.

#### R
- `rlang` paketi kurulur.

#### Haskell
- `haskell_setup.sh` ile geliştirme ortamı (ghci + cabal) kurulur.

#### Zig
- `zig_setup.sh $ZİG-SÜRÜM` ile istenen sürüm kurulumu yapılır.
- `$HOME/.local/zig` altına kurulur.

#### Ada
- `alire_setup.sh $ALIRE-SÜRÜM` ile istenen `alire` paket yöneticisi sürüm kurulumu yapılır.
- `alire` kullanılarak Ada derleyicisi kurulur.

#### PHP
- `php` (8.x) paketi kurulur.

#### Erlang, Elixir
- `erlang` ve `elixir` paketleri kurulur.
- Paket yöneticisi için `rebar3_setup.sh` kullanılır.

#### Nodejs
- `nodejs` paketleri kurulur.
- Paket yöneticisi `npm` paketin içinde gelmektedir.

#### V
- `vlang_setup.sh` ile kurulumu yapılır.
- `$HOME/.local/vlang` altına kurulur.

#### Gleam
- `gleam_setup.sh $GLEAM-SÜRÜM` ile istenen sürüm kurulumu yapılır.
- `/usr/local/bin/` altına kurulur.
- `erlang` paketi de otomatik kurulur.

#### Perl
- Perl 5.x sürümü kurulu gelmektedir.

#### Chapel
- `chapel` paketi kurulur.

#### Ats2
- `ats2` paketi kurulur.

## Geliştirme Ortamı

Milis Linux'ta grafik arayüzü kod düzenleyicisi olarak varsayılan olarak kurulu gelen **Geany** ve **Vscodium** (vscodium-bin) uygulamalarını kullanabilirsiniz.
Ayrıca uçbirim ortamında kullanabileceğiz **nano** ve **vim** uygulamaları da mevcuttur.
