# Codex Web Local

Versão derivada localmente de miuuyy/codex-chatgpt-web v6.1.4 (MIT), mantida em https://github.com/LckOFc/Codex-Web-Local. Não é um produto oficial da OpenAI. A licença original é preservada em LICENSE.

Mantém as capacidades e limitações do projeto original: modelos ChatGPT Web no Codex, streaming, contexto e imagens, modo browser-only, integração Full harness por MCP/tunnel e modo manual.

Mudanças: nome e ID do aplicativo próprios; diretório de dados .codex-web-local; serviços com identificadores próprios; porta padrão 17851; links sociais opcionais; atualização automática pelos binários upstream desabilitada para não substituir este build.

O login continua sendo uma sessão web em navegador incorporado. A porta CDP local e seus riscos permanecem: este fork não foi convertido em uma arquitetura de autenticação isolada nem auditado integralmente. Use os dados de sessão apenas em um Mac confiável.

O uso real requer login, smoke test, instalação de modelos e, para ferramentas locais, configuração MCP/tunnel. A disponibilidade de modelos depende da conta. Não há garantia de funcionamento permanente diante de mudanças no ChatGPT Web.
