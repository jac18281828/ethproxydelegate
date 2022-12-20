FROM ghcr.io/collectivexyz/foundry:latest

ARG PROJECT=ethproxydelegate
WORKDIR /workspaces/${PROJECT}
RUN chown -R mr.mr .
COPY --chown=mr:mr . .
ENV USER=mr
USER mr
ENV PATH=${PATH}:~/.cargo/bin
#RUN yarn install
#RUN ~mr/.cargo/bin/forge test -vvv --gas-report

#RUN ~jac/.cargo/bin/forge build --sizes
#RUN ~jac/.cargo/bin/forge test -vvv

