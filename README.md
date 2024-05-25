# Aplicação de Microserviços com Node.js e RabbitMQ

Esta aplicação é composta por múltiplos microserviços desenvolvidos em Node.js, utilizando RabbitMQ para comunicação assíncrona entre eles. O objetivo principal é fazer o upload de imagens, processá-las (convertendo para preto e branco), e notificar o usuário quando o processamento estiver concluído. Além do sistema de logger utilizando o mongoDB como armazenamento.

## Microserviços

1. **Serviço de User (user-service)**
    - Gerencia a criação de contas e o login dos usuários.
    - Gerencia o upload de imagens pelos usuários.
    - Envia imagens para o RabbitMQ para processamento.

2. **Serviço de Processamento de Imagens (proccess-image-service)**
    - Consome mensagens de imagens do RabbitMQ.
    - Converte as imagens para preto e branco.
    - Notifica que o processo acabou.

3. **Serviço de Log (log-service)**
    - Registra ações dos usuários, como login, criação de conta e upload e processamento de imagens.

4. **Serviço de Notificação (notification-service)**
    - Notifica os usuários quando o processamento está concluído.
    - Demais notificações

5. **Gateway**
    - Porta de entrada para os microserviços.
    - Encaminha as requisições para os serviços apropriados.

## Estrutura do Projeto

```bash
├── user-service
│   ├── server.js
│   ├── Dockerfile
│   └── ...
├── proccess-image-service
│   ├── server.js
│   ├── Dockerfile
│   └── ...
├── logger-service
│   ├── server.js
│   ├── Dockerfile
│   └── ...
├── notification-service
│   ├── server.js
│   ├── Dockerfile
│   └── ...
└── gateway
│   ├── nginx.conf
│   ├── Dockerfile
│   └── ...
└── docker-compose.yaml
```
## Executando com docker

```bash
    docker-compose up --build
```