FROM archlinux:latest

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm base-devel git sudo pacman-contrib\ 
    && useradd -m builder && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers &&\
    pacman -Scc

COPY --chown=root:root --chmod=0755 ./build_n_run.sh /bin/build_n_run
COPY --chown=root:root --chmod=0755 ./run_fixperm.sh /bin/run_fixperm

RUN echo '#!/usr/bin/env bash' > /usr/local/bin/entrypoint.sh && \
    echo 'set -e' >> /usr/local/bin/entrypoint.sh && \
    echo '' >> /usr/local/bin/entrypoint.sh && \
    echo 'echo "Start container"' >> /usr/local/bin/entrypoint.sh && \
    echo 'sudo chown -R builder:builder /home/builder' &&\
    echo 'sudo chmod +w /home/builder' &&\
    echo 'exec "$@"' >> /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

USER builder

WORKDIR /home/builder

RUN git clone https://aur.archlinux.org/yay-bin.git &&\
    cd yay-bin &&\
    makepkg -si --noconfirm &&\
    rm -rf yay-bin &&\
    yay --version &&\
    sudo pacman -Scc


VOLUME /home/builder

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]