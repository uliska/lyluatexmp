manual:
	@lua -e "if tonumber(io.popen('pandoc -v'):read():gsub('pandoc (.*)', '%1'):sub(1,1)) < 2 then print('Pandoc >= 2 required') ; os.exit(1) ; end"
	pandoc --pdf-engine=lualatex \
	--pdf-engine-opt=-shell-escape -V fontfamily=libertine --toc-depth=4 -o lyluatexmp.pdf lyluatexmp.md

clean:
	git clean -fXd
