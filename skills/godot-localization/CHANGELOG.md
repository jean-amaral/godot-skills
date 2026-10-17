# Changelog — godot-localization

## 1.0.0 — 2026-10-17

- Skill inicial a partir da documentação oficial de internacionalização da Godot 4.7, com a regra do pacote de que todo jogo nasce em pt-BR + en: texto por chave com `tr()` (nada de string solta visível ao jogador), placeholders nomeados, contexto e plural pela engine, pipeline CSV/PO com registro em Localization → Translations, troca em runtime via `TranslationServer` com textos reaplicados, remaps, fontes/fallback e pseudolocalização, com template de glossário e convenção de chaves.
