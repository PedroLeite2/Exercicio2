# avaliacaoex2

# Jogo Educativo de Endereçamento IPv4

## Autores

- Pedro Leite
- Pedro Silva
- Ricardo Brandão

## Descrição

Este projeto consiste num jogo educativo desenvolvido em Flutter, que visa ajudar os jogadores a explorarem e aprenderem mais sobre conceitos de redes de computadores, em particular sobre o endereçamento IPv4.

O jogo gera automaticamente perguntas sobre:

- Network ID
- Broadcast
- Verificação de se dois IPs estão no mesmo segmento de rede

O jogador escolhe o nível de dificuldade e responde a perguntas, ganhando ou perdendo pontos com base nas suas respostas. O score é armazenado em tempo real numa base de dados SQL Lite.

---

## Requisitos Funcionais

1. **Autenticação**

   - Registo e login de utilizadores utilizando Firebase Authentication.
   - Apenas utilizadores autenticados podem responder a perguntas e ver o seu score.

2. **Perguntas**

   - Gerar perguntas automaticamente com base em três níveis de dificuldade:
     - **Nível 1**: IPv4 com máscaras /8, /16 e /24.
     - **Nível 2**: Sub-redes.
     - **Nível 3**: Super-redes.
   - Tipos de pergunta:
     - Cálculo de Network ID.
     - Cálculo de endereço Broadcast.
     - Verificação de pertença a um mesmo segmento de rede.

3. **Pontuação**

   - Nível 1: +10 pontos por acerto, -5 por erro.
   - Nível 2: +20 pontos por acerto, -10 por erro.
   - Nível 3: +30 pontos por acerto, -15 por erro.
   - Feedback imediato ao jogador após cada resposta.

4. **Scoreboard**

   - Visualização do top 5 melhores scores, mesmo sem login.

5. **Ranking**

   - O score é guardado por utilizador e atualizado em tempo real no SQL Lite.

6. **Validações**
   - Garantir que as respostas introduzidas são válidas.

---

## Requisitos Não Funcionais

1. **Desempenho**

   - A aplicação deve oferecer tempos de resposta rápidos, especialmente na geração e validação das perguntas.

2. **Escalabilidade**

   - A arquitetura deve permitir adicionar novas perguntas ou níveis no futuro sem grande reestruturação.

3. **Segurança**

   - Proteção dos dados dos utilizadores com Firebase Authentication.
   - Dados armazenados no SQL Lite de forma segura.

4. **Usabilidade**

   - Interface gráfica simples e intuitiva para facilitar a interação do utilizador.
   - Feedback visual claro após resposta a cada pergunta.

5. **Manutenibilidade**

   - Código documentado e organizado com boas práticas.
   - README explicativo do propósito e funcionamento da aplicação.

6. **Colaboração**
   - Uso de ferramentas de versionamento como o GitHub para desenvolvimento colaborativo.

---

## Observações

- Projeto realizado no âmbito da unidade curricular de **Programação de Dispositivos Móveis** no **ISLA - Instituto Politécnico de Gestão e Tecnologia**.
- Ano letivo: **2024/2025**
- Docente: **Helder Rodrigo Pinto**
