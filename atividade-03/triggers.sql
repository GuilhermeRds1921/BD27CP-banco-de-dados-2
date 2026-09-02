-- Guilherme Rodrigues dos Santos
-- Luiz Eduardo Caldas Kramer


-- Tiggers
-- 1. Crie um trigger que converta automaticamente o campo nome para letras maiúsculas antes de cada INSERT ou UPDATE.
CREATE FUNCTION nome_maiusculo()
RETURNS TRIGGER AS $$
BEGIN
    NEW.nome := UPPER(NEW.nome);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_nome_maiusculo
BEFORE INSERT OR UPDATE ON usuarios
FOR EACH ROW
EXECUTE FUNCTION nome_maiusculo();




-- 2. Crie um trigger que registre em uma tabela de log o usuário que realizou a operação (usando current_user).
CREATE FUNCTION logs()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_operacoes (usuario_id, operacao, usuario_banco, data_operacao)
    VALUES (COALESCE(NEW.id, OLD.id), TG_OP, current_user, NOW());
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log
AFTER INSERT OR UPDATE OR DELETE ON usuarios
FOR EACH ROW
EXECUTE FUNCTION logs();




-- 3. Crie um trigger que impeça a atualização de emails para valores nulos.
CREATE FUNCTION impedir_email_nulo()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' AND NEW.email IS NULL THEN
        RAISE EXCEPTION 'O campo email não pode ser nulo';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_email_nulo
BEFORE UPDATE ON usuarios
FOR EACH ROW
EXECUTE FUNCTION impedir_email_nulo();




-- 4. Crie um trigger que atualize uma coluna saldo_total em uma tabela de contas sempre que uma transação for inserida ou deletada
CREATE FUNCTION atualizar_saldo()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE contas
        SET saldo_total = saldo_total + NEW.valor
        WHERE id = NEW.conta_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE contas
        SET saldo_total = saldo_total - OLD.valor
        WHERE id = OLD.conta_id;
    END IF;
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_saldo
AFTER INSERT OR DELETE ON transacoes
FOR EACH ROW
EXECUTE FUNCTION atualizar_saldo();




-- 5. Crie um trigger que envie uma notificação (usando NOTIFY) quando o email de um usuário for atualizado.
CREATE FUNCTION notificar()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM pg_notify('notificar',
        json_build_object('id', NEW.id, 'email_antigo', OLD.email, 'email_novo', NEW.email)::text);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_notificar
AFTER UPDATE OF email ON usuarios
FOR EACH ROW
WHEN (OLD.email IS DISTINCT FROM NEW.email)
EXECUTE FUNCTION notificar();




-- 6. Crie um trigger que valide se o campo email contém um formato válido (ex.: contém @ e .) antes de INSERT ou UPDATE.
CREATE FUNCTION validar_email()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.email NOT LIKE '%@%.%' THEN
        RAISE EXCEPTION 'Formato de email inválido: %', NEW.email;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_email
BEFORE INSERT OR UPDATE ON usuarios
FOR EACH ROW
EXECUTE FUNCTION validar_email();


