# Install pyenv
curl https://pyenv.run | bash
cp .bashrc .bashrc.orig
sed -i '$a export PYENV_ROOT="$HOME/.pyenv"\n[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"\neval "$(pyenv init -)"' ~/.bashrc
source .bashrc

# Check Version
pyenv --version
